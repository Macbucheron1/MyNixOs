{ config, pkgs, ... }: {
  users.users.mac = {
    isNormalUser = true;
    description = "Mac";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = false; # To allow remote nixos rebuilds

  programs.zsh.enable = true;
}
