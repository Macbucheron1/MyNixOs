{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [ "alacritty" ];
      
      input = {
        kb_layout = "fr";
    };
  };
}
