{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {

      bind =[
        "SUPER, RETURN, exec, alacritty" # Open terminal
        "SUPER, Q, killactive"          # Fermer une fenêtre
      ];
      
      input = {
        kb_layout = "fr";
      };
    };
  };
}
