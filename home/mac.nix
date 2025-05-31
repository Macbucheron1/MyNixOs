{ config, pkgs, ... }: {
  home.username = "mac";
  home.homeDirectory = "/home/mac";

  home.packages = with pkgs; [ 
    zsh 
  ];

  programs.git = {
    enable = true;
    userName = "Macbucheron1";
    userEmail = "nathan@example.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  home.stateVersion = "24.05";
}
