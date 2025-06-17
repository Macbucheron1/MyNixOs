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
├── hardware-configuration.nix  # Auto-generated hardware setup: disks, bootloader, file systems, etc.
│
├── hosts/
│   └── mac-nixos.nix           # System configuration specific to the host "mac-nixos". Imports system-level modules.
│
├── modules/                    # System-level NixOS modules
│   ├── home-manager.nix        # Declares and integrates the home-manager module at the system level
│   ├── hyprland.nix            # Enables and configures Hyprland at the system level (window manager, drivers, etc.)
│   ├── network.nix             # Configures networking (e.g. NetworkManager)
│   ├── nix.nix                 # Core Nix and flakes-related configuration, includes garbage collector
│   ├── openssh.nix             # OpenSSH server settings
│   ├── packages.nix            # Global system packages (environment.systemPackages)
│   └── user-mac.nix            # System-level configuration for the "mac" user (shell, groups, etc.)
│
├── home/                       # Home Manager configuration (user-level)
│   ├── mac.nix                 # Home Manager entry point for user "mac", importing user-level modules
│   └── modules/                # Modules specific to the user "mac"
│       ├── development/        # Development tools and configurations
│       │   └── default.nix     # Entry point for development modules
│       ├── gui/                # GUI-related configurations, split into submodules
│       │   ├── default.nix     # Entry point importing all GUI modules
│       │   ├── hyprland.nix    # Hyprland window manager configuration
│       │   ├── terminal.nix    # Alacritty terminal configuration with systemd service
│       │   └── wallpaper.nix   # Hyprpaper wallpaper service configuration
│       ├── media/              # Media-related tools and configurations
│       │   └── default.nix     # Entry point for media modules
│       └── shell/              # Shell configurations, split into submodules
│           ├── default.nix     # Entry point importing all shell modules
│           ├── starship.nix    # Starship prompt configuration
│           └── zsh.nix         # Zsh shell configuration with aliases
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

### Manage system storage

The system is configured with an automatic garbage collector that runs weekly and removes generations older than 7 days.

You can manually clean unused NixOS generations with:

```bash
# Clean user profile generations
nix-clean

# Clean all system generations (requires sudo)
nix-clean-all
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
  - [x] Add a greetd and hyprlock for login
  - [ ] Discover and configure styling options
  - [x] Add hyprpaper for wallpaper
    - [ ] use [this](wallpaper for theme)
- [ ] Rice tf out of this

# 🧰 Ressources

- https://github.com/accmeboot/dotfiles
- https://github.com/Aylur/dotfiles
- [Terminal qui est super beau](https://media.discordapp.net/attachments/1184471801271681035/1380267291954122833/Screenshot_2025-06-05_at_16.29.22.png?ex=68434196&is=6841f016&hm=44c6020be508a4662bb06a2d068d0f0c2772310205e93cf04164a58b5dda909e&=&format=webp&quality=lossless)
