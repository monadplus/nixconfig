{ config, pkgs, lib, ... }:

with lib;
with builtins;

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

  # Use the latest kernel - This solver suspend and bright issue.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;
  boot.cleanTmpDir = true;

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  location.latitude = 41.3828939;
  location.longitude = 2.1774322;

  services.redshift = {
    enable = true;
    temperature.day = 5500;
    temperature.night = 3700;
  };

  # https://github.com/rycee/home-manager/issues/463
  home-manager.users.arnau = import ./home.nix { inherit pkgs config; };

  # https://github.com/nix-community/NUR/
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Fix for hamster: https://github.com/NixOS/nixpkgs/issues/27498
  services.dbus.packages = with pkgs; [ gnome2.GConf gnome3.dconf hamster-time-tracker ];

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
    # TODO not working...
     #inputMethod.enabled = "ibus";
     #inputMethod.ibus.engines = with pkgs.ibus-engines; [ uniemoji ];
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
    extraLayouts."us-custom" = {
      description = "US layout with alt-gr greek";
      languages = [ "eng" ];
      symbolsFile = ./dotfiles/keyboard/us-custom;
    };

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
          haskellPackages.X11
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
      hamster &

      # Miscellaneous
      ${pkgs.xorg.xset}/bin/xset r rate 265 40

      # Unfortunately since the HM autorandr module is not set up to detect hardware events, that is, it won't react to simply inserting the HDMI cable. It would be sweet to fix so that it does and if anybody know udev or something well enough to figure out how to do it that would be great.I suspect it's not doable without hooking it up in the system level configuration, though. Something like what the autorandr Makefile does.
      ${pkgs.autorandr}/bin/autorandr -c
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

  # https://nixos.wiki/wiki/Actkbd
  services.actkbd = {
      enable = true;
      # sudo lsinput # Find the input device (be aware that not all devices are mapped to one input..)
      # nix-shell -p actkbd --run "sudo actkbd -n -s -d /dev/input/event#" # Replace '#' by event ID
      bindings =
        let
          toggleVol      = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master toggle'"; };
          incrVol        = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master 5%- unmute'"; };
          decrVol        = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master 5%+ unmute'"; };
          toggleMic      = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer set Capture toggle'"; };
          incrBrightness = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl set 10%-"; };
          decrBrightness = keys: { inherit keys; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl set +10%"; };
        in concatLists [
          # audio (fix: https://github.com/NixOS/nixpkgs/issues/24297)
          #( map toggleVol [ [ 59 ] [ 113 ] ] )
          #( map incrVol [ [ 60 ] [ 114 ] ] )
          #( map decrVol [ [ 61 ] [ 115 ] ] )

          ( map toggleMic [ [ 62 ] [ 190 ] ] )

          #( map incrBrightness [ [ 224 ] ] )
          #( map decrBrightness [ [ 225 ] ] )
        ];
    };

  # TODO disable because it clashes with docker postgres
  #services.postgresql = {
    #enable = true;
    #package = pkgs.postgresql_11;
    #enableTCPIP = true;
    #authentication = pkgs.lib.mkOverride 10 ''
      #local all all trust
      #host all all ::1/128 trust
    #'';
    #initialScript = pkgs.writeText "backend-initScript" ''
      #CREATE DATABASE example;
    #'';
  #};

  virtualisation = {
    docker = {
      enable = true;
    };
    # Virtualbox
  };

}
