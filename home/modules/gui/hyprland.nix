{ pkgs, ... }: {
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
      
      # Lancement automatique des applications
      exec-once = [
        "waybar" # Lancer Waybar au démarrage
      ];
    };

    # --------- End Hyprland's rice ---------
  };
}