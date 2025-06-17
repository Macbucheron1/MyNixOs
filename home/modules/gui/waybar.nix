{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    # Utilisation de la version stable depuis nixpkgs
    package = pkgs.waybar;
    
    # Style de Waybar (CSS)
    style = ''
      * {
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 12pt;
        font-weight: bold;
        border-radius: 0px;
        transition-property: background-color;
        transition-duration: 0.5s;
      }
      window#waybar {
        background-color: rgba(21, 18, 27, 0.9);
        border-bottom: 2px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
      }
      #workspaces button {
        padding: 0 10px;
        color: #a6adc8;
      }
      #workspaces button.active {
        color: #ffffff;
        background-color: #285577;
        border-bottom: 2px solid #ffffff;
      }
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #custom-power {
        padding: 0 10px;
        margin: 0 4px;
        color: #ffffff;
        border-bottom: 2px solid #ffffff;
      }
      #pulseaudio {
        color: #89b4fa;
      }
      #network {
        color: #a6e3a1;
      }
      #battery {
        color: #f38ba8;
      }
      #battery.charging {
        color: #a6e3a1;
      }
    '';

    # Configuration de Waybar
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      margin = "0";
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];

      # Configuration des modules
      "hyprland/workspaces" = {
        format = "{name}";
        active-only = false;
        on-click = "activate";
        sort-by-number = true;
      };
      
      "clock" = {
        format = "{:%H:%M %d/%m/%Y}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          weeks-pos = "right";
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
      
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 Muet";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        tooltip = true;
        on-click = "pavucontrol";
      };
      
      "network" = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰖪  Déconnecté";
        tooltip = true;
        tooltip-format = "{ifname} : {ipaddr}/{cidr}";
      };
      
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰂄 {capacity}%";
        format-alt = "{time} {icon}";
        format-icons = [ "󱃍" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };
      
      "tray" = {
        icon-size = 16;
        spacing = 8;
      };
    }];
  };
  
  # S'assurer que les dépendances nécessaires sont installées
  home.packages = with pkgs; [
    font-awesome    # Pour les icônes
    pavucontrol     # Pour le contrôle du volume
  ];
}