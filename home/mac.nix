{ config, pkgs, stylix, ... }: {
  home.username = "mac";
  home.homeDirectory = "/home/mac";

  imports = [
    ./modules/shell # Contains Zsh and Starship configuration
    ./modules/alacritty # Contains Alacritty configuration
    ./modules/hyprland
    stylix.homeManagerModules.stylix
  ];

  programs.git = {
    enable = true;
    userName = "Macbucheron1";
    userEmail = "nathandeprat@hotmai.fr";
  };

  stylix = {
    enable = true;                          # indispensable:contentReference[oaicite:3]{index=3}
    image = ./../wallpaper/basic.png; # chemin vers l'image de fond
    fonts.monospace.package = pkgs.jetbrains-mono;
    polarity = "dark";
  };

  home.stateVersion = "25.05";
}
