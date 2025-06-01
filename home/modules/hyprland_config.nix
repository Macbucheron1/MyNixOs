{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      
      # Lance alacritty (terminal) au lancement
      exec-once = [ "alacritty" ];


      bind =[
        "SUPER, RETURN, exec, alacritty"
      ];

      # Defini le clavier en français      
      input = {
        kb_layout = "fr";
      };
    };
  };
}
