{ ... }: {
  imports = [
    ./terminal.nix
    ./hyprland.nix
    ./wallpaper.nix
    ./lock.nix      # Nouveau module pour Hyprlock
  ];
}