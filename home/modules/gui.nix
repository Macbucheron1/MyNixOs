{ pkgs, ... }: {
  home.packages = with pkgs; [
    alacritty
  ];

  # Hypaper configuration
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${../../wallpapers/basic.png}
    preload = ${../../wallpapers/extended.png}
    wallpaper = eDP-1, ${../../wallpapers/basic.png}
    wallpaper = , ${../../wallpapers/extended.png}
  '';

  # Service utilisateur pour hyprpaper
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;
    # La configuration est lue à partir du fichier défini dans xdg.configFile ci-dessus
  };

  # Service utilisateur pour Alacritty (auto-démarrage)
  systemd.user.services.alacritty = {
    Unit = {
      Description = "Alacritty Terminal";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };
    Service = {
      ExecStart = "${pkgs.alacritty}/bin/alacritty";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  wayland.windowManager.hyprland = {
    # Activate hyprland's configuration
    enable = true;

    # --------- Start Hyprland's rice ---------

    # Hyprland's configuration
    settings = {
      # Raccourci clavier
      bind =[
        "SUPER, RETURN, exec, alacritty" # Open terminal
        "SUPER, Q, killactive"          # Fermer une fenêtre
        "SUPER, V, togglefloating"      # Basculer en mode flottant
      ];

      # Raccourci clavier + souris
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # Defini le clavier en français      
      input = {
        kb_layout = "fr";
      };
    };

    # --------- End Hyprland's rice ---------
  };

}
