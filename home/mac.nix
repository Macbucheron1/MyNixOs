{ config, pkgs, ... }: {
  home.username = "mac";
  home.homeDirectory = "/home/mac";

  imports = [
    ./modules/shell.nix # Contains Zsh and Starship configuration
    ./modules/gui.nix
    ./modules/hyprland_config.nix
  ];

  programs.git = {
    enable = true;
    userName = "Macbucheron1";
    userEmail = "nathandeprat@hotmai.fr";
  };

  home.stateVersion = "25.05";
}
