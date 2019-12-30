{ config, pkgs, lib, ... }:

with lib;
with builtins;

{
  networking.hostName = "hades";

  # Use the latest kernel - This solver suspend and bright issue.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;
  boot.cleanTmpDir = true;

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

  networking.useDHCP = false;
  networking.interfaces.enp3s0f0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

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
      # WORK
    };
    extraConfig = ''
      ctrl_interface=/run/wpa_supplicant
      ctrl_interface_group=wheel
    '';
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
          ( map toggleVol [ [ 113 ] [ 59 ] ] )
          ( map incrVol [ [ 114 ] [ 60 ] ] )
          ( map decrVol [ [ 115 ] [ 61 ] ] )

          ( map toggleMic [ [ 190 ] [ 62 ] ] )

          ( map incrBrightness [ [ 224 ] ] )
          ( map decrBrightness [ [ 225 ] ] )
        ];
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
  };
  services.blueman.enable = true; # GUI for bluetooth

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };
  # https://nixos.wiki/wiki/ALSA
  sound.enable = true;

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

  services.redshift = {
    enable = true;
    temperature.day = 5500;
    temperature.night = 3700;
  };
}
