{ config, pkgs, inputs, ... }: {
  home.username = "mac";
  home.homeDirectory = "/home/mac";

  imports = [
    ./modules/shell # Importe ./modules/shell/default.nix qui importe tous les sous-modules shell
    ./modules/gui   # Importe ./modules/gui/default.nix qui importe tous les sous-modules gui
    ./modules/development # Pour de futurs modules de développement
    ./modules/media # Pour de futurs modules multimédias
  ];

  programs.git = {
    enable = true;
    userName = "Macbucheron1";
    userEmail = "nathandeprat@hotmai.fr";
  };

  home.stateVersion = "25.05";
}
