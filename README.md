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

### Wi-fi

TODO

### Audio

alsamixer
