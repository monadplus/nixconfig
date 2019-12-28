{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    ref = "master";
    rev = "0f1c9f25cf03cd5ed62db05c461af7e13f84a7b6";
  };
in
{
  imports = [
    "${home-manager}/nixos"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  system.stateVersion = "19.09";

  location.latitude = 41.3828939;
  location.longitude = 2.1774322;

  # https://github.com/rycee/home-manager/issues/463
  home-manager.users.arnau = import ./home.nix { inherit pkgs config; };

  # https://github.com/nix-community/NUR/
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Only keep the last 500MiB of systemd journal.
  services.journald.extraConfig = "SystemMaxUse=500M";

  # Collect nix store garbage and optimise daily.
  nix.gc.automatic = true;
  nix.optimise.automatic = true;

  # Enable the OpenSSH daemon (allow secure remote logins)
  services.openssh.enable = true;
  programs.ssh.startAgent = true; # Start ssh-agent as systemd service

  # Battery info
  services.upower.enable = true;

  services.printing = {
    enable = true;
    # drivers = (with pkgs; [ gutenprint cups-bjnp hplip cnijfilter2 ]);
  };

  i18n = lib.mkForce {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Madrid";

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      powerline-fonts
      nerdfonts
    ];
  };

  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";

    desktopManager = {
       default = "none";
       xterm.enable = false;
    };

    displayManager.lightdm = {
      enable = true;
      greeters.gtk.indicators = [ "~host" "~spacer" "~clock" "~spacer" "~a11y" "~session" "~power"];
    };

    windowManager = {
      default = "xmonad";
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = /etc/nixos/dotfiles/xmonad/xmonad.hs;
        extraPackages = haskellPackages : [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmobar
        ];
      };
    };

    displayManager.sessionCommands = ''
      # Must be run before the rest of the apps in order to make them appear.
      stalonetray &

      # Apps
      xscreensaver -no-splash &
      blueman-manager &
      wpa_gui &
      clipmenud &
      Enpass &

      # Miscellaneous
      ${pkgs.xorg.xset}/bin/xset r rate 265 40
    '';
  };

  users = {
    mutableUsers = false; # Don't allow imperative style
    extraUsers = [
      {
        name = "arnau";
        createHome = true;
        home = "/home/arnau";
        group = "users";
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
          "docker"
          "transmission"
        ];
        isNormalUser = true;
        uid = 1000;
        useDefaultShell = false;
        shell = "/run/current-system/sw/bin/zsh";
        # mkpasswd
        hashedPassword = "$6$hKXoaMQzxJ$TI79FW9KtvORSrQKP5cqZR5fzOISMLDyH80BnBlg8G61piAe6qCw.07OVWk.6MfQO1l3mBhdTckNfnBpkQSCh0";
      }
    ];
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
  };

  documentation = {
    man.enable = true;
  };

  programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    # https://github.com/Powerlevel9k/powerlevel9k/wiki/Install-Instructions#nixos
    promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";
  };

  # BitTorrent client:
  services.transmission = {
    enable = true;
    user = "transmission";
    group = "transmission";
    port = 9091;
    #settings = {
      #download-dir = "/var/lib/transmission/Downloads";
      #incomplete-dir = "/var/lib/transmission/.incomplete";
      #incomplete-dir-enabled = true;
    #};
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE DATABASE example;
    '';
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    # Virtualbox
  };

}
