{ pkgs, ... }: {
  home.packages = with pkgs; [
    alacritty
    hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = /etc/nixos/wallpapers/basic.png
    preload = /etc/nixos/wallpapers/extended.png
    wallpaper = eDP-1, /etc/nixos/wallpapers/basic.png
    wallpaper = , /etc/nixos/wallpapers/extended.png
  '';

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "alacritty"
        "hyprpaper"
      ];

      input = {
        kb_layout = "fr";
      };

      general = {
        gaps_in = 6;
        gaps_out = 12;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 6;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.0";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 800"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default, slide"
        ];
      };

      dwindle = {
        pseudotile = true; # Enable pseudotiling
        preserve_split = true; # Preserve the split ratio when new windows are opened
      };

      misc = {
        disable_hyprland_logo = true;
      };
    };
  };
}
