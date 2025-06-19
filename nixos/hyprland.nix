{ pkgs, config, inputs, ... }: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.xserver.enable = false; # assure qu'on ne démarre pas X11
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # support Wayland pour Electron/Chromium apps
  };
}
