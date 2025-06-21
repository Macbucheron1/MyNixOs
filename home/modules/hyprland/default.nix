{ pkgs, ... }: {
  
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ./cursor.nix
  ];
}