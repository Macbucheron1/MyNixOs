# 🐧 NixOS Flake Configuration – mac-nixos

This repository contains my personal and minimalist NixOS configuration, managed with Flakes and Home Manager.
It's designed to be modular, versioned, and reproducible — ideal for development, pentesting, and customization.

## 🧩 Features

- Flake-based system configuration (`/etc/nixos`)
- Modular layout with clean separation of concerns
- Home Manager integration for user-level config
- Minimal starting point (no GUI, no extra packages)

## 📁 Structure

```shell
.
├── flake.nix  # Entry point of the NixOs flake system. Defines inputs and system configuration
├── flake.lock # Same but generated so do not touch
├── hardware-configuration.nix # Auto generated file that declares disk/boot/hardware setup
├── hosts/
│ └── mac-nixos.nix  # system config of the machine. Import system modules
├── modules/  # NixOs systemm modules
│ ├── network.nix
│ ├── nix.nix
│ ├── openssh.nix
│ ├── packages.nix
│ └── user-mac.nix
├── home # Home manager configuration
│   ├── mac.nix # Configuration for the user mac
│   └── modules # User specific modules. Since there is only mac there are all for mac
│       └── shell.nix
└── README.md
```

## 🚀 Usage

### Apply system config:

> [!CAUTION]
> Needs to be run as `mac`
```bash
nixupdate
```

# 🔧 TODO

- [x] Integrate `zsh` with `starship` prompt
- [ ] Install some kind of fetch to look cool
- [ ] Add a gui
  - [x] Hyprland as the Window Manager
  - [x] Adding FR keyboard layout for hyprland
  - [ ] Waybar as the status bar
  - [ ] Wofi or as Launcher
  - [x] Alacritty as terminal
- [ ] Rice `starship` prompt
- [ ] Rice tf out of this

