{ config, pkgs, ... }: {
  home.username = "mac";
  home.homeDirectory = "/home/mac";

  imports = [
    ./modules/shell # Contains Zsh and Starship configuration
    ./modules/alacritty # Contains Alacritty configuration
    ./modules/hyprland
  ];

  programs.git = {
    enable = true;
    userName = "Macbucheron1";
    userEmail = "nathandeprat@hotmai.fr";
  };

  catppuccin = {
    flavour = "mocha";
    accent  = "blue";
    enable  = true;
  };

  home.stateVersion = "25.05";
}
