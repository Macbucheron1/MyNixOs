{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    zsh
    tree
  ];

  programs.firefox.enable = true;
}
