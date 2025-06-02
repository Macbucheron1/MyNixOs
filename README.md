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
├── flake.nix                   # Entry point for the NixOS flake system. Declares inputs and output configurations.
├── flake.lock                  # Auto-generated lock file that pins all dependencies (do not edit manually).
├── hardware-configuration.nix # Auto-generated hardware setup: disks, bootloader, file systems, etc.
│ 
├── hosts/
│   └── mac-nixos.nix           # System configuration specific to the host "mac-nixos". Imports system-level modules.
│ 
├── modules/                    # System-level NixOS modules
│   ├── home-manager.nix        # Declares and integrates the home-manager module at the system level
│   ├── hyprland.nix            # Enables and configures Hyprland at the system level (window manager, drivers, etc.)
│   ├── network.nix             # Configures networking (e.g. NetworkManager)
│   ├── nix.nix                 # Core Nix and flakes-related configuration
│   ├── openssh.nix             # OpenSSH server settings
│   ├── packages.nix            # Global system packages (environment.systemPackages)
│   └── user-mac.nix            # System-level configuration for the "mac" user (shell, groups, etc.)
│ 
├── home/                       # Home Manager configuration (user-level)
│   ├── mac.nix                 # Home Manager entry point for user "mac", importing user-level modules
│   └── modules/                # Modules specific to the user "mac"
│       ├── gui.nix             # GUI-related tools and packages (launchers, themes, etc.)
│       └── shell.nix           # Shell configuration (Zsh, Starship, aliases, etc.)
│
├── wallpapers/                 # Static assets used as backgrounds or themes
│   ├── basic.png
│   └── extended.png
│ 
└── README.md                   # Project documentation and development notes
```

## 🚀 Usage

### Test the build of current config 

> [!CAUTION]
> Needs to be run as `mac`
```bash 
nixtest
```

### Apply system config:

> [!CAUTION]
> Needs to be run as `mac`
```bash
nixupdate
```

# 🔧 TODO

- [x] Integrate `zsh` with `starship` prompt
- [ ] Install some kind of fetch to look cool
- [ ] Add a basic gui
  - [x] Hyprland as the Window Manager
  - [x] Adding FR keyboard layout for hyprland
  - [ ] Waybar as the status bar
  - [ ] Wofi or as Launcher
  - [x] Alacritty as terminal
- [ ] Rice `starship` prompt
- [ ] Configure hyprland
  - [ ] Add a display manager to launch on hyprland
  - [ ] Discover and configure styling options
  - [ ] Add hyprpaper for wallpaper
    - [ ] use [this](wallpaper for theme)
- [ ] Rice tf out of this

