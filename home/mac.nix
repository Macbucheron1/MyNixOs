{ config, pkgs, ... }: {
  home.username = "mac";
  home.homeDirectory = "/home/mac";

  programs.git = {
    enable = true;
    userName = "Macbucheron1";
    userEmail = "nathan@example.com";
  };

  home.packages = with pkgs; [

  ];

  home.stateVersion = "24.05";
}
