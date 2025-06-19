{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    zsh
    xdg-utils  # Provides xdg-open and other XDG utilities
  ];

}
