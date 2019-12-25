## Pending configurations for nixOS

[X] Power Management, suspend laptop (needed to update kernel) and battery info
[X] Wi-fi: for home
[X] audio, toggle audio and toggle micro
[X] Screenlight and redshift
[~] Clipboard manager: I tried:
       copyq: requires a graphic environment and doesnt work on systemd (I dont know if it possible to disable gui of daemon)
       clipmenu: almost working (I even saw a git issue with my same problem) but it doesnt work as kb
       parcellite: no gui
[X] Bluetooth headphones : https://nixos.wiki/wiki/Bluetooth
[X] Interactive with public wi-fi (gui) => wpa_gui
[X] Multiple screens
[X] Xmonad + Xmobar: first iteration doesn't have to be shinny, only usable.
[ ] Configure Xmonad
[ ] Configure Xmobar
[ ] Configure stalonetray
[ ] A terminal emulator managed by config files (konsole is bad at this)
[ ] Bluetooth volume
[ ] LightDM tune
[ ] trackpad: increase sensivity

## Not working

[ ] xmonad .xsession not loading. I tried setting up the following but nah

```
xsession.enable = true;
xsession.initExtra = ''
  FOO=BAR
'';
xsession.windowManager.command = ''${pkgs.xmonad-with-packages}/bin/xmonad'';
```

[ ] Multiscreen using config file doesn't work well out of the box (you must run `autorandr -c`)
  - Answer from rycee: Unfortunately since the HM autorandr module is not set up to detect hardware events, that is, it won't react to simply inserting the HDMI cable. It would be sweet to fix so that it does and if anybody know udev or something well enough to figure out how to do it that would be great.I suspect it's not doable without hooking it up in the system level configuration, though. Something like what the autorandr Makefile does.

