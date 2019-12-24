# Nix configuration

> Please, update me!

First, you need to install a fresh NixOS following the [manual](https://nixos.org/nixos/manual/index.html#sec-installation).

Then, you need to have `git` on the system.
If installing is required do `nix-env -iA pkgs.git`.
You will need to import your github private key (or create a new one `ssh-keygen -t rsa -b 4096 -C "arnauabella@gmail.com"`)
and it to openSSH daemon `ssh-add /home/arnau/.ssh/github`.

```bash
$ sudo mv /etc/nixos/hardware-configuration.nix /tmp/hardware-configuration.nix
$ sudo rm /etc/nixos
$ sudo git clone git@github.com:monadplus/nixconfig.git /etc/nixos

# Probably you will need to create a new hosts/your_hostname folder.
$ sudo mv /tmp/hardware-configuration.nix /etc/nixos/hosts/<<your_hostname>>/hardware-configuration.nix

# Edit your configuration (copy/pasting from another configuration would help)
$ sudo vim /etc/nixos/hosts/<<your_hostname>>/configuration.nix

# Symlink your configuration to /etc/hosts
$ ln -s /etc/nixos/hosts/<<your_hostname>>/configuration.nix /etc/nixos/config.nix
$ ln -s /etc/nixos/hosts/<<your_hostname>>/hardware-configuration.nix /etc/nixos/hardware.nix
```

Before realising your configuration you must add (test if you really need it) home-manager channels:

```bash
$ nix-channel --add https://github.com/rycee/home-manager/archive/release-19.09.tar.gz home-manager
$ nix-channel --update
```

To install everything:

```bash
$ sudo nixos-rebuild switch
$ reboot
```

## Command-lines

### Monitors

`arandr` is the graphical version of `xrandr` (use this one.)

`xrandr` (cli):

```bash
xrandr # List monitors and options
xrandr --auto # Detect monitors and connect them
xrandr --output HDMI-1 --off # Disable hdmi monitor
xrandr --output HDMI-1 --right-of eDP-1  # Place HDMI-1 at the right
# ^^^^^^ To change mirror monitoring
```

We installed `autoxrandr` to change config when monitor is plugged in.

### Wi-fi

Known networks are set on configuration.nix

wpa_gui: GUI, simple to use.

wpa_cli:

```
$ wpa_cli
> scan
OK
<3>CTRL-EVENT-SCAN-RESULTS
> scan_results
bssid / frequency / signal level / flags / ssid
00:00:00:00:00:00 2462 -49 [WPA2-PSK-CCMP][ESS] MYSSID
11:11:11:11:11:11 2437 -64 [WPA2-PSK-CCMP][ESS] ANOTHERSSID

# If the SSID does not have password authentication, you must explicitly configure the network as keyless by replacing the command

> save_config
OK
> quit
```

### Audio

alsamixer

### Bluetooth

blueman-manager (gui) / blueman-applet (daemon)

Command line:

```
$ bluetoothctl
[bluetooth] # power on
[bluetooth] # agent on
[bluetooth] # default-agent
[bluetooth] # scan on
...put device in pairing mode and wait [hex-address] to appear here...
[bluetooth] # pair [hex-address]
[bluetooth] # connect [hex-address]
```

### Clibpard manager (Not working..)

[clipmenu](https://github.com/cdown/clipmenu)

Requires a systemd daemon runnning: `clipmenud`

And then you can access the tray: `https://github.com/cdown/clipmenu`


### Dropbox

Automatically started and mounted (not sure how..)
