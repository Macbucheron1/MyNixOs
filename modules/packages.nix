{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
  ];

  programs.firefox.enable = true;
}
