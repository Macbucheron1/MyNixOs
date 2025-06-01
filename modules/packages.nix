{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    tree
  ];

  programs.firefox.enable = true;
}
