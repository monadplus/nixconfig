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
      # Smartphone
      "Monad" = {
        pskRaw = "2193ddbc3b5587f6d692c04c0e7879bfcc19f65398bcad2b0fa2b0143b082506";
      };
      # CALAFAT
      "MOVISTAR_7B1B" = {
        pskRaw = "6a1d731b3e07251fed01072b0e2d088c5f2388442b0a30745164dbc2e4069946";
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
    trackpoint.enable = true;
    trackpoint.emulateWheel = true; # While holding middle button
    trackpoint.speed = 97; # Kernel default
    trackpoint.sensitivity = 128; # Kernel default
  };

  # https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    #config = {
      #General = {
        #Enable = ["Source" "Sink" "Media" "Socket"];
      #};
    #};
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
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
