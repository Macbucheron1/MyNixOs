# configuration.nix (ou ton module flake)
{ pkgs, ... }:

let
  myWallpaper = ./wallpapers/hacker_nix.png;   # chemin vers ton PNG
in
{
  services.xserver.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      # suffixe = flavor choisi ci-dessous
      theme = "catppuccin-mocha";
      settings.Theme.CursorTheme = "Bibata-Modern-Ice";
    };
    defaultSession = "hyprland";
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.breeze-icons
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg

    # ▶︎ Thème Catppuccin modifié
    (catppuccin-sddm.override {
      flavor          = "mocha";          # base sombre
      background      = myWallpaper;      # pixel-art
      loginBackground = true;             # fond aussi sur l’écran de mot de passe
      font            = "JetBrainsMono Nerd Font";
      fontSize        = "10";
    })
  ];

  services.xserver.xkb.layout = "fr";
  security.polkit.enable       = true;
}
