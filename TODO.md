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
[ ] Xmobar on top of screen
[ ] Configure Xmonad
[ ] Configure Xmobar
[ ] Configure stalonetray
[ ] A terminal emulator managed by config files (konsole is bad at this)
[ ] Bluetooth volume
[ ] LightDM tune
[ ] trackpad: increase sensivity
[ ] hoogle: local database
[ ] enpass plugin for firefox (write it yourself)
    or picking a free-software alternative would be great ;)
[ ] AWS cli
[ ] AWS config declarative (?)

## Missing from macOS
[ ] psql pgcli
[ ] utorrent
[ ] Markdown processor
[ ] tyme2: hours of work management
[ ] OpenOffice, libreOffice, Word
[ ] SWI-Prolog
[ ] tunnelblick or alternative
[ ] minikube ?


## Failed to make it work

[ ] Multiscreen using config file doesn't work well out of the box (you must run `autorandr -c`)
  - Answer from rycee: Unfortunately since the HM autorandr module is not set up to detect hardware events, that is, it won't react to simply inserting the HDMI cable. It would be sweet to fix so that it does and if anybody know udev or something well enough to figure out how to do it that would be great.I suspect it's not doable without hooking it up in the system level configuration, though. Something like what the autorandr Makefile does.
