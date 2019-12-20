{ config, pkgs, lib, ... }:

with lib;

{
  networking.hostName = "hades";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;
  boot.cleanTmpDir = true;

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  #networking.wireless.enable = true;
  networking.networkmanager.enable = true;

  sound.enable = true;

  # TODO light doesn't work
  #programs.light.enable = true;
  #services.actkbd = {
      #enable = true;
      #bindings = [
        #{ keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
        #{ keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
      #];
    #};

  hardware = {

    # https://github.com/Hummer12007/brightnessctl
    # TODO light doesn't work
    brightnessctl.enable = true;

    trackpoint.enable = true;
    trackpoint.emulateWheel = true; # While holding middle button
    trackpoint.speed = 97; # Kernel default
    trackpoint.sensitivity = 128; # Kernel default

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

  # TODO doesnt work ? I dont even know how to test it
  services.redshift = {
    # this setting is affected by location.latitude/location.longitude
    enable = true;
    temperature.day = 5500;
    temperature.night = 2700;
  };
}
