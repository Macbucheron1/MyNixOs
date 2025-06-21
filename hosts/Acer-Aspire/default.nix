{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    # Core modules
    ./../../nixos/core/network.nix
    ./../../nixos/core/nix.nix
    ./../../nixos/core/audio.nix
    
    ./../../nixos/user-mac.nix
    ./../../nixos/openssh.nix
    ./../../nixos/hyprland.nix
    ./../../nixos/system_packages.nix
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

    # Bootloader.
  boot.loader = {
    # ――― général ―――
    timeout = 3;                     # menu visible 3 s (0 = instantané, -1 = illimité)

    systemd-boot = {
      enable             = true;
      configurationLimit = 5;        # déjà mis chez toi
      consoleMode        = "auto";   # "max" = résolution max, "0" = 80×25, etc.
      editor             = false;    # désactive la touche « e » dans le menu
    };

    efi.canTouchEfiVariables = true;
    grub.enable = false;
  };

  system.stateVersion = "25.05";
}

