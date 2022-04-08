iosmanthus 💓 NixOS
==========

My current and **always evolving** NixOS configuration files, always ready for [`@MuggleLego`](https://github.com/MuggleLego).

## Programs

The `home/xserver/default.nix` file contains details about all the software I use, but here's a shout-out to the ones I use the most and that are customized to my needs.

| Type           |                   Program                    |
| :------------- | :------------------------------------------: |
| Editor         |   [VSCode](https://code.visualstudio.com)    |
| Launcher       |  [Rofi](https://github.com/davatorium/rofi)  |
| Shell          |          [Zsh](https://www.zsh.org)          |
| Status Bar     |     [Polybar](https://polybar.github.io)     |
| Terminal       | [Kitty](https://github.com/kovidgoyal/kitty) |
| Window Manager |            [i3](https://i3wm.org)            |

## Structure

Here is an overview of the folders' structure:

```
.
.
├── configuration.nix
├── flake.lock
├── flake.nix
├── hardware-common.nix
├── home
│   ├── base16-kitty.nix
│   ├── default.nix
│   ├── shell
│   │   ├── alias.nix
│   │   ├── default.nix
│   │   └── starship.nix
│   ├── tmux.nix
│   ├── vscode
│   │   ├── default.nix
│   │   ├── update_installed_exts.sh
│   │   └── update-shell.nix
│   └── xserver
│       ├── default.nix
│       ├── i3.nix
│       ├── polybar
│       │   ├── default.nix
│       │   └── mpris.nix
│       └── rofi.nix
├── machines
│   ├── common
│   │   ├── default.nix
│   │   └── machine
│   │       └── default.nix
│   └── iosmanthus
│       ├── default.nix
│       ├── legion
│       │   ├── default.nix
│       │   ├── hardware-configuration.nix
│       │   └── monitors.nix
│       └── xps
│           ├── default.nix
│           ├── hardware-configuration.nix
│           └── monitors.nix
├── Makefile
├── misc
│   └── default.nix
├── network
│   ├── default.nix
│   ├── leaf-tun.nix
│   ├── proxy
│   │   └── default.nix
│   └── tun2socks.nix
├── overlays
│   ├── default.nix
│   ├── firmware.nix
│   ├── leaf.nix
│   ├── polybar-fonts.nix
│   ├── tun2socks.nix
│   └── yesplaymusic.nix
├── packages
│   ├── clash-premium.nix
│   ├── leaf.nix
│   ├── polybar-fonts.nix
│   ├── tun2socks.nix
│   └── yesplaymusic.nix
├── README.md
├── secrets
│   └── iosmanthus
│       ├── default.nix
│       ├── id_ecdsa_iosmanthus
│       ├── id_rsa_iosmanthus
│       └── ssh_config
├── system
│   ├── default.nix
│   └── monitoring.nix
├── utils
│   └── branch-overlay.nix
├── virtualisation
│   └── default.nix
└── xserver-entry
    ├── default.nix
    ├── fonts.nix
    └── monitors.nix
```

- `Makefile`: the build and installation script.
- `flake.nix`: home and system configurations.
- `home`: all the user programs, services and dotfiles.
- `network`: contains two modules of `tun2socks`.
- `secrets`: private keys/config of mine, encrypted with [sops](https://github.com/mozilla/sops)
