# 🐧 NixOS Flake Configuration – mac-nixos

This repository contains my personal and minimalist NixOS configuration, managed with Flakes and Home Manager. 
It's designed to be modular, versioned, and reproducible — ideal for development, pentesting, and customization.

## 🧩 Features

- Flake-based system configuration (`/etc/nixos`)
- Modular layout with clean separation of concerns
- Home Manager integration for user-level config
- Minimal starting point (no GUI, no extra packages)

## 📁 Structure

```
.
├── flake.nix
├── flake.lock
├── hardware-configuration.nix
├── hosts/
│ └── mac-nixos.nix
├── modules/
│ ├── network.nix
│ ├── nix.nix
│ ├── openssh.nix
│ ├── packages.nix
│ └── user-mac.nix
└── home/
└── mac.nix
```


## 🚀 Usage

### Apply system config:

```bash
sudo nixos-rebuild switch --flake .#mac-nixos
```

# 🔧 TODO

- [ ] Integrate `zsh` with `starship` prompt
- [ ] Install some kind of fetch to look cool
- [ ] Add a gui
  - [ ] Hyprland as the Window Manager
  - [ ] Waybar as the status bar
  - [ ] Wofi or as Launcher
  - [ ] Alacritty as terminal
- [ ] Rice tf out of this

