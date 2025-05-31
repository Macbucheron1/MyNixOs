{ config, pkgs, ... }: {
  users.users.mac = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ tree ];
  };
}
