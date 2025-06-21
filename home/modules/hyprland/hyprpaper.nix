{ pkgs, ... }: {
  services.hyprpaper = {
    enable = true;                   # installe le paquet et crée un service systemd-user
    settings = {                     # génère ~/.config/hypr/hyprpaper.conf
      ipc = "on";
      preload = [ "${./../../../wallpaper/basic.png}" ];
      wallpaper = [
        "eDP-1,${./../../../wallpaper/basic.png}"
      ];
    };
  };
}