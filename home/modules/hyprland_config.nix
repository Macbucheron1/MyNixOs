{ pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [ "alacritty" ];
    };

  };
}
