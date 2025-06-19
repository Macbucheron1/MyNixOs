{ pkgs, ... }: {
  home.packages = with pkgs; [
    alacritty
    thunar
    xfce.thunar-volman  # For auto-mounting removable drives
    xfce.thunar-archive-plugin  # For archive support
    firefox  # Web browser for xdg-open to use
  ];
}
