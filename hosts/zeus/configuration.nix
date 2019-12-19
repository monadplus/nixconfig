{ config, pkgs, lib, ... }:

with lib;

{
  networking.hostName = "zeus";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true; # TODO popOS ?
  boot.loader.timeout = 8;
  boot.cleanTmpDir = true;

  # TODO gnome doesn't want this set to true
  #networking.wireless.enable = true;

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
    # TODO
    # xkbOptions = "eurosign:e";

    # Enable touchpad support.
    # libinput.enable = true;

    videoDrivers = [ "intel" ];

    desktopManager = {
       default = "none";
       xterm.enable = false;
       plasma5.enable = true;
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

    #windowManager = {
      #default = "xmonad";
      #xmonad = {
        #enable = true;
        #enableContribAndExtras = true;
        #config = /etc/nixos/dotfiles/xmonad/xmonad.hs;
        #extraPackages = haskellPackages : [
          #haskellPackages.xmonad-contrib
          #haskellPackages.xmonad-extras
          #haskellPackages.xmobar
        #];
      #};
    #};

    displayManager.sessionCommands = ''
      ${pkgs.xorg.xset}/bin/xset r rate 265 40
    '';
  };
}
