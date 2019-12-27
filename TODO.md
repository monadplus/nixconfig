## Pending configurations for nixOS

[X] Power Management, suspend laptop (needed to update kernel) and battery info
[X] Wi-fi: for home
[X] audio, toggle audio and toggle micro
[X] Screenlight and redshift
[X] Clipboard manager: copyq(), clipmenu(*), parcellite(). As systemd it doesnt work, I put it on xsession.
[X] Bluetooth headphones : https://nixos.wiki/wiki/Bluetooth
[X] Interactive with public wi-fi (gui) => wpa_gui
[X] Multiple screens
[X] Xmonad + Xmobar: first iteration doesn't have to be shinny, only usable.
[X] touchpad: increase sensivity
[X] AWS cli
[ ] Xmobar on top of screen
[ ] Configure Xmonad, xmobar and stalonetray
[ ] Terminal: termite, st, ..
[ ] Wallpaper
[ ] Bluetooth volume
[ ] LightDM tune
[ ] hoogle: local database, reload autoaticlaly ?
[ ] enpass plugin for firefox (write it yourself)
    or picking a free-software alternative would be great ;)
[ ] Time tracker (both doesnt work)
    - hamster-time-tracker
    - super-productivity
[ ] Setting up kubernetes on nixos: https://rzetterberg.github.io/kubernetes-nixos.html

## Failed to make it work

[ ] Multiscreen using config file doesn't work well out of the box (you must run `autorandr -c`)
  - Answer from rycee: Unfortunately since the HM autorandr module is not set up to detect hardware events, that is, it won't react to simply inserting the HDMI cable. It would be sweet to fix so that it does and if anybody know udev or something well enough to figure out how to do it that would be great.I suspect it's not doable without hooking it up in the system level configuration, though. Something like what the autorandr Makefile does.
