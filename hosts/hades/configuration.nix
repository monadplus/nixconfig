{ config, pkgs, lib, ... }:

with lib;

{
  networking.hostName = "hades";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 8;
  boot.cleanTmpDir = true;

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  sound.enable = true;

  hardware = {
    # TODO
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
      support32Bit = true;
      package = pkgs.pulseaudioFull;
    };
  };

  # battery management
  services.tlp.enable = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.logind.extraConfig = ''
    # Controls how logind shall handle the system power and sleep keys.
    HandlePowerKey=suspend
  '';
}
