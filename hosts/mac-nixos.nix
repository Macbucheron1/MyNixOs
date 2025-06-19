{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./../hardware-configuration.nix

    # Core modules
    ./../modules/core/network.nix
    ./../modules/core/system_packages.nix
    ./../modules/core/nix.nix
    ./../modules/core/audio.nix
    
    ./../modules/user-mac.nix
    ./../modules/openssh/default.nix
    ./../modules/hyprland/default.nix
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

