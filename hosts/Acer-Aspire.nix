{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./../hardware-configuration.nix

    # Core modules
    ./../nixos/core/network.nix
    ./../nixos/core/nix.nix
    ./../nixos/core/audio.nix
    
    ./../nixos/user-mac.nix
    ./../nixos/openssh.nix
    ./../nixos/hyprland.nix
    ./../nixos/system_packages.nix
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}

