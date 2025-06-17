{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./../hardware-configuration.nix
    ./../modules/network.nix
    ./../modules/user-mac.nix
    ./../modules/packages.nix
    ./../modules/openssh.nix
    ./../modules/nix.nix
    ./../modules/hyprland.nix 
    ./../modules/home-manager.nix
    ./../modules/secrets.nix  # Chemin mis à jour vers le module de secrets
    ./../modules/login-manager.nix  # Ajout du gestionnaire de connexion SDDM
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

