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
    ./hardware-configuration.nix
    "${home-manager}/nixos"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };

  # You should change this only after NixOS release notes say you should.
  system.stateVersion = "19.09";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; # TODO popOS ?
  boot.loader.timeout = 8;
  boot.cleanTmpDir = true;

  networking.hostName = "arnau";
  networking.wireless.enable = true;

  sound.enable = true;

  hardware = {
    # cpu.intel.updateMicrocode = true;
    # opengl.driSupport = true;
    # opengl.driSupport32Bit = true;
    # opengl.extraPackages = [ pkgs.vaapiIntel ];
    # trackpoint.enable = false;
    # trackpoint.emulateWheel = false;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  virtualisation = {
    # TODO docker requires sudo..
    docker = {
      enable = true;
    };
  };

  i18n = lib.mkForce {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    # supportedLocales = [];
    # consoleUseXkbConfig = true; # console kb settings = xserver kb settings
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  fonts = {
    fontconfig.enable = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      powerline-fonts  # agnoster theme uses this
      inconsolata
      fira-mono
      ubuntu_font_family
    ];
  };

  # Enable the OpenSSH daemon (allow secure remote logins)
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    # drivers = (with pkgs; [ gutenprint cups-bjnp hplip cnijfilter2 ]);
  };

  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    # libinput.enable = true;

    videoDrivers = [ "intel" ];

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "arnau";
        theme = pkgs.fetchurl {
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
        extraPackages = haskellPackages : [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
	  haskellPackages.xmobar
          haskellPackages.xmonad
        ];
      };
    };

    # TODO Not sure why I need this
    autoRepeatDelay = 200; # milliseconds
    autoRepeatInterval = 30; # milliseconds

    displayManager.sessionCommands = ''
      ${pkgs.xorg.xset}/bin/xset r rate 265 40
    '';
  };

  # battery management
  # services.tlp.enable = true

  programs = {
    command-not-found.enable = true;
    ssh.startAgent = true; # Start OpenSSH agent when you log in (e.g. ssh-add ..)
    zsh.enable = true;
    # https://github.com/Powerlevel9k/powerlevel9k/wiki/Install-Instructions#nixos
    zsh.promptInit = "source ${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";
  };

  documentation = {
    man.enable = true;
  };

  users = {
    mutableUsers = false; # Don't allow imperative style
    extraUsers = [ 
      {
        name = "arnau";
        createHome = true;
        home = "/home/arnau";
	group = "users";
	extraGroups = [ "wheel" "networkmanager" ]; # docker
	isNormalUser = true;
	useDefaultShell = false;
	shell = "/run/current-system/sw/bin/zsh";
        hashedPassword = "$6$hKXoaMQzxJ$TI79FW9KtvORSrQKP5cqZR5fzOISMLDyH80BnBlg8G61piAe6qCw.07OVWk.6MfQO1l3mBhdTckNfnBpkQSCh0";
      }
    ];
 };

 services.logind.extraConfig = ''
   # Controls how logind shall handle the system power and sleep keys.
   HandlePowerKey=suspend
 '';

 environment.variables = {
   EDITOR = "vim";
   VISUAL = "vim";
   BROWSER = "firefox";
 };
 
 # https://github.com/rycee/home-manager/issues/463
 home-manager.users.arnau = import ./home.nix { inherit pkgs config; };
}
