{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    zsh
  ];

  programs.firefox.enable = true;
}
