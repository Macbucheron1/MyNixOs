{ pkgs, config, inputs, ... }: {

  programs.hyprland = {
    # Activate hyprland (installation etc)
    enable = true;

    # Specify the package (version) of hyprland to use
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    
    # Portals version to use. Portals allow communication between application (share files, screen, etc...)
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    # Allow X11 application to be executed (like firefox)
    xwayland.enable = true;
  };
  
  # Installer hyprlock depuis le flake dédié
  environment.systemPackages = with pkgs; [
    inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.xserver.enable = false; # assure qu'on ne démarre pas X11
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # support Wayland pour Electron/Chromium apps
  };
}
