# 🐧 NixOS Flake Configuration – Acer-Aspire

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
├── flake.nix  # Entry point of the NixOS flake system. Defines inputs and system configuration
├── flake.lock # Generated lock file
├── hosts/
│   └── Acer-Aspire/
│       ├── default.nix                # System config of the machine
│       └── hardware-configuration.nix # Hardware setup for the machine
├── nixos/   # NixOS system modules
│   ├── core/
│   │   ├── network.nix
│   │   ├── nix.nix
│   │   └── audio.nix
│   ├── hyprland.nix
│   ├── openssh.nix
│   ├── system_packages.nix
│   └── user-mac.nix
├── home/    # Home Manager configuration
│   ├── mac.nix
│   └── modules/
│       ├── gui.nix
│       ├── hyprland_config.nix
│       └── shell.nix
└── README.md
```

## 🚀 Usage

### Apply system config:

> [!CAUTION]
> Needs to be run as `mac`

```bash
sudo nixos-rebuild switch --flake .#Acer-Aspire
```

# 🔧 TODO

- [x] Integrate `zsh` with `starship` prompt
- [ ] Install some kind of fetch to look cool
- [ ] Add a gui
  - [x] Hyprland as the Window Manager
  - [ ] Adding FR keyboard layout for hyprland
  - [ ] Waybar as the status bar
  - [ ] Wofi or as Launcher
  - [x] Alacritty as terminal
- [ ] Rice `starship` prompt
- [ ] Rice tf out of this

## Ressources

https://github.com/anotherhadi/nixy
https://github.com/louis-thevenet/nixos-config/tree/main
https://github.com/vimjoyer/nixconf/tree/796238ed92b953c77c357aa208f377adae20bf06
https://gitlab.com/Zaney/zaneyos
https://github.com/Frost-Phoenix/nixos-config/tree/7e8f3e1761fa01dbaf14183d259e5df8a91dfed8