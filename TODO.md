## Pending configurations for nixOS

- [ ] Bluetooth headset a2dp and volume
- [ ] Bluetooth randomly stops working (no adapter found on `bluetoothctl list`) after resume.
- [ ] Printer

### Buetooth randomly stops

The service seems ok:

```
$ journalctl -u bluetooth.service -f

-- Logs begin at Wed 2020-01-01 11:36:37 CET. --
Feb 04 18:57:41 hades bluetoothd[31243]: Stopping SDP server
Feb 04 18:57:41 hades bluetoothd[31243]: Exit
Feb 04 18:57:41 hades systemd[1]: bluetooth.service: Succeeded.
Feb 04 18:57:41 hades systemd[1]: Stopped Bluetooth service.
Feb 04 18:57:41 hades systemd[1]: Starting Bluetooth service...
Feb 04 18:57:41 hades bluetoothd[32288]: Bluetooth daemon 5.50
Feb 04 18:57:41 hades bluetoothd[32288]: Unknown key Enable for group General in /nix/store/4cd4ivd4vay32k2qddjgjnik88y83f48-bluez-5.50/etc/bluetooth/main.conf
Feb 04 18:57:41 hades systemd[1]: Started Bluetooth service.
Feb 04 18:57:41 hades bluetoothd[32288]: Starting SDP server
Feb 04 18:57:41 hades bluetoothd[32288]: Bluetooth management interface 1.14 initialized
```

blueman-manager fails with no adaptor:

```
$ blueman-manager

blueman-manager version 2.1.1 starting
blueman-manager 19.02.23 ERROR    Manager:118 on_dbus_name_appeared: Default adapter not found, trying first available.
blueman-manager 19.02.23 ERROR    Manager:122 on_dbus_name_appeared: No adapter(s) found, exiting
```

I tried the following but nothing: https://github.com/blueman-project/blueman/wiki/Troubleshooting#debugging-blueman

```
$ blueman-applet -d

blueman-applet version 2.1.1 starting
Stale PID, overwriting
blueman-applet 18.57.55 WARNING  PluginManager:147 __load_plugin: Not loading DhcpClient because its conflict has higher priority
blueman-tray version 2.1.1 starting
Stale PID, overwriting
blueman-tray version 2.1.1 starting
There is an instance already running
blueman-applet 18.57.55 WARNING  PluginManager:147 __load_plugin: Not loading PPPSupport because its conflict has higher priority
blueman-applet 18.57.55 WARNING  DiscvManager:109 update_menuitems: warning: Adapter is None
```

```
$ bluetoothctl list

Empty
```
