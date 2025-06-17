# Configuration du gestionnaire de connexion SDDM pour Hyprland
{ pkgs, ... }:

let
  # Ton fond d’écran, embarqué dans le dépôt NixOS
  myWallpaper = ./wallpapers/hacker_nix.png;

  # Palette dérivée du pixel-art
  bgColor       = "#0A0E24";  # fond très sombre bleu-nuit
  cyanAccent    = "#03A9C0";  # cyan / turquoise (écrans & logo)
  magentaHover  = "#FF2E88";  # rose néon (survol, yeux, clavier)
  goldHighlight = "#E6B43E";  # or patiné (casque, icônes)
in
{
  ## 1. SDDM + Wayland
  services.xserver.enable = true;

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-hack";          # nom final du thème
      settings.Theme = {
        CursorTheme = "Bibata-Modern-Ice";  # curseur clair dans la même gamme
      };
    };
    defaultSession = "hyprland";
  };

  ## 2. Paquets nécessaires + thème Catppuccin surchargé
  environment.systemPackages = with pkgs; [
    libsForQt5.breeze-icons
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtsvg

    # Thème SDDM recoloré : "catppuccin-hack"
    (catppuccin-sddm.override {
      flavor         = "mocha";            # base sombre
      background     = myWallpaper;
      primaryColor   = cyanAccent;         # boutons & champs actifs
      secondaryColor = magentaHover;       # couleur de survol
      accentColor    = goldHighlight;      # sliders, cases cochées…
      font           = "JetBrainsMono Nerd Font";
      fontSize       = "10";               # légèrement plus grand
    })
  ];

  ## 3. Clavier & polkit
  services.xserver.xkb.layout = "fr";
  security.polkit.enable = true;
}
