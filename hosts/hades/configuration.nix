{ config, pkgs, lib, ... }:

with lib;

{
  networking.hostName = "hades";

  # Use the latest kernel - This solver suspend and bright issue.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;
  boot.cleanTmpDir = true;

  nix.maxJobs = 8;
  nix.buildCores = 0; # Use all cores of your CPU
  # ^^^^^^^^^^ Some builds may become non-deterministic with this option

  # This includes support for suspend-to-RAM and powersave features on laptops.
  powerManagement = {
    enable = true;
    # TLP sets this to null => let TLP do its work.
    #cpuFreqGovernor = "ondemand";
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

  # Wi-Fi: wpa_supplicant
  networking.wireless = {
    enable = true;
    # wpa_passphrase ESSID PSK
    networks = {
      # HOME

      # TODO connect to the nearest
      "MOVISTAR_8348" = {
        pskRaw = "9be2248888cc9c79b7f81aef7a17c9f3f6be1e33e19a573b5c0a8178831307c6";
      };
      "MOVISTAR_8348_Extender" = {
        pskRaw = "9be2248888cc9c79b7f81aef7a17c9f3f6be1e33e19a573b5c0a8178831307c6";
      };

      # ------------------
      # UNIVERSITY

      # ------------------
      # WORK
    };
    extraConfig = ''
      ctrl_interface=/run/wpa_supplicant
      ctrl_interface_group=wheel
    '';
  };

  # https://nixos.wiki/wiki/NixOS:extend_NixOS
  # This is an example
  #systemd.services."copyq" = {
      #wantedBy = [ "default.target" ];
      #after = [ "graphical.target" ];
      #description = "Copyq daemon";
      #serviceConfig = {
        #ExecStart = ''${pkgs.copyq}/bin/copyq'';
        #Restart = "always";
        #RestartSec = 0.5; # secs
      #};
  #};

  # https://nixos.wiki/wiki/Actkbd
  services.actkbd = {
      enable = true;
      # sudo lsinput # Find the input device (be aware that not all devices are mapped to one input..)
      # nix-shell -p actkbd --run "sudo actkbd -n -s -d /dev/input/event#" # Replace '#' by event ID
      bindings = [
        # audio (fix: https://github.com/NixOS/nixpkgs/issues/24297)
        { keys = [ 113 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master toggle'"; }
        { keys = [ 114 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master 5%- unmute'"; }
        { keys = [ 115 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer -q set Master 5%+ unmute'"; }
        # Toggle Microphone
         { keys = [ 190 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/runuser -l arnau -c 'amixer set Capture toggle'"; }
        # Screen bright
        { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl set 10%-"; }
        { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/brightnessctl set +10%"; }
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
  # Manage audio using actkbd (doesnt work, manually set up.)
  #sound.mediaKeys.enable = true; # Disable on desktop managers.


  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # TODO doesnt work ? I dont even know how to test it
  services.redshift = {
    # this setting is affected by location.latitude/location.longitude
    enable = true;
    temperature.day = 5500;
    temperature.night = 3700;
  };
}
