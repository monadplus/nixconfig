{ config, pkgs, lib, ... }:

with lib;

{
  networking.hostName = "zeus";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; # TODO popOS ?
  boot.loader.timeout = 8;
  boot.cleanTmpDir = true;

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

  # battery management
  # services.tlp.enable = true

  virtualisation = {
    # TODO docker requires sudo..
    docker = {
      enable = true;
    };
  };

  services.logind.extraConfig = ''
    # Controls how logind shall handle the system power and sleep keys.
    HandlePowerKey=suspend
  '';

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
}
