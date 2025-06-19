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

  # XDG mime applications configuration
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["thunar.desktop"];
        "text/html" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
      };
    };
  };

  home.stateVersion = "25.05";
}
