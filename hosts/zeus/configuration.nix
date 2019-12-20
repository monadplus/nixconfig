{ config, pkgs, lib, ... }:

with lib;

{
  networking.hostName = "zeus";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 8;
  boot.cleanTmpDir = true;

  # TODO gnome doesn't want this set to true
  #networking.wireless.enable = true;

  sound.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  services.xserver.videoDrivers = [ "intel" ];
}
