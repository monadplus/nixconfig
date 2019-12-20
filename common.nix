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
    allowUnfree = true; # Allow packages with non-free licenses.
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
      nerdfonts # vim-devicons
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

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "arnau";
        theme =
          pkgs.fetchurl {
            url    = "https://github.com/ylwghst/nixos-light-slim-theme/archive/1.0.0.tar.gz";
            sha256 = "0cc701k920zhy54srd1qwb5rcxqp5adjhnl154z7c0276csglzw9";
          };
      };
    };

    windowManager = {
      default = "xmonad";
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        # nb. `xmonad --recompile` will no longer work!
        config = /etc/nixos/dotfiles/xmonad/xmonad.hs;
        extraPackages = haskellPackages : [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmobar
        ];
      };
    };

    displayManager.sessionCommands = ''
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
        extraGroups = [ "wheel" "networkmanager" "video" "docker"];
        isNormalUser = true;
        uid = 1000;
        useDefaultShell = false;
        shell = "/run/current-system/sw/bin/zsh";
        hashedPassword = "$6$hKXoaMQzxJ$TI79FW9KtvORSrQKP5cqZR5fzOISMLDyH80BnBlg8G61piAe6qCw.07OVWk.6MfQO1l3mBhdTckNfnBpkQSCh0";
      }
    ];
  };

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
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


  virtualisation = {
    docker = {
      enable = true;
    };
  };

}
