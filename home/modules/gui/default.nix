{ ... }: {
  imports = [
    ./terminal.nix
    ./hyprland.nix
    ./wallpaper.nix
    ./lock.nix      # Module pour Hyprlock
    ./waybar.nix    # Nouveau module pour Waybar
  ];
}