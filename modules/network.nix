{ config, pkgs, ... }: {
  networking.hostName = "Mac-NixOs";
  networking.networkmanager.enable = true;
}
