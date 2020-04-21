{ config, pkgs, lib, ... }:

with lib;
with builtins;

{
  networking.hostName = "hades";

  # This includes support for suspend-to-RAM and powersave features on laptops.
  powerManagement = {
    enable = true;
  };

  # https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
  services.tlp = {
    enable = true;
    # Example: https://gist.github.com/pauloromeira/787c75d83777098453f5c2ed7eafa42a
    extraConfig = ''
      START_CHARGE_THRESH_BAT0=70
      STOP_CHARGE_THRESH_BAT0=85
    '';
  };

  services.logind.extraConfig = ''
    # Controls how logind shall handle the system power and sleep keys.
    HandlePowerKey=suspend
  '';

  networking.wireless = {
    enable = true;
    # wpa_passphrase ESSID PSK
    networks = {
      # HOME
      "MOVISTAR_8348" = {
        pskRaw = "9be2248888cc9c79b7f81aef7a17c9f3f6be1e33e19a573b5c0a8178831307c6";
      };
      "MOVISTAR_8348_Extender" = {
        pskRaw = "9be2248888cc9c79b7f81aef7a17c9f3f6be1e33e19a573b5c0a8178831307c6";
      };
      "Monad" = {
        pskRaw = "338529ea97241bd0320fc7d9a4058647a9da447a5f1a70ba1129c2ae289e7461";
      };
      # UNIVERSITY
      "eduroam" = {
        auth = ''
          ssid="eduroam"
          key_mgmt=WPA-EAP
          eap=TTLS
          group=CCMP
          phase2="auth=PAP"
          anonymous_identity="anonymous@upc.edu"
          identity="arnau.abella"
          password="asdadaADSA131231!#!@#!"
          ca_cert="/home/arnau/upc.crt"
          priority=10
        '';
      };
      # WORK
    };
    extraConfig = ''
      ctrl_interface=/run/wpa_supplicant
      ctrl_interface_group=wheel
    '';
  };

  hardware = {
    # https://github.com/Hummer12007/brightnessctl
    brightnessctl.enable = true;

    trackpoint.enable = true;
    trackpoint.emulateWheel = true; # While holding middle button
    trackpoint.speed = 97; # Kernel default
    trackpoint.sensitivity = 128; # Kernel default
  };

  # https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    extraConfig = "
      [General]
      Enable=Source,Sink,Media,Socket
    ";
  };
  services.blueman.enable = true; # GUI for bluetooth

  # https://nixos.wiki/wiki/ALSA
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Touchpad
  services.xserver.libinput = {
    enable = true;
    tapping = false;
    middleEmulation = false;
    additionalOptions = ''
      Option "AccelSpeed" "0.3"        # Mouse sensivity
      Option "TapButton2" "0"          # Disable two finger tap
      Option "VertScrollDelta" "-180"  # scroll sensitivity
      Option "HorizScrollDelta" "-180"
      Option "FingerLow" "40"          # when finger pressure drops below this value, the driver counts it as a release.
      Option "FingerHigh" "70"
    '';
  };
}
