{ pkgs, ... }: {
  # Hypaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${../../../wallpapers/basic.png}
    preload = ${../../../wallpapers/extended.png}
    wallpaper = eDP-1, ${../../../wallpapers/basic.png}
    wallpaper = , ${../../../wallpapers/extended.png}
  '';

  # Service utilisateur pour hyprpaper
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    # La configuration est lue à partir du fichier défini dans xdg.configFile ci-dessus
  };
}