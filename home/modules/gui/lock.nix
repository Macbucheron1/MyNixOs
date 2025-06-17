{ pkgs, lib, config, inputs, ... }:

let
  # ------------------------------------------------------------
  # 1.  Variables de confort
  # ------------------------------------------------------------
  wallpaper = ../../../wallpapers/basic.png;      # Chemin vers le fond d'écran de secours
  font = "JetBrainsMono Nerd Font";
  username = "mac";                               # Nom d'utilisateur

  # ------------------------------------------------------------
  # 2.  Script de capture d'écran et flou
  # ------------------------------------------------------------
  hyprlock-blur = pkgs.writeShellScriptBin "hyprlock-blur" ''
    #!/usr/bin/env bash

    # Capture d'écran pour chaque moniteur
    # Obtenir la liste des moniteurs
    MONITORS=$(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name')
    
    # Capturer chaque moniteur
    for monitor in $MONITORS; do
      ${pkgs.grim}/bin/grim -o $monitor -l 0 /tmp/screenshot-$monitor.png &
    done
    
    # Attendre que tous les processus de capture soient terminés
    wait
    
    # Lancer hyprlock avec les captures d'écran comme fond
    hyprlock
  '';

  # ------------------------------------------------------------
  # 3.  Définition de la conf Hyprlock sous forme d'attrset
  # ------------------------------------------------------------
  hyprlockConfig = {
    # === Bloc global ===
    general = {
      disable_loading_bar = false;          # Afficher une barre de chargement
      hide_cursor = true;                   # Masquer le curseur en mode verrouillé
      grace = 0;                            # Pas de période de grâce
      no_fade_in = false;                   # Animation de fondu à l'entrée
    };

    # === Fond d'écran + effets (utilise les captures d'écran) ===
    background = let
      # Configuration générique pour un moniteur
      mkMonitorBg = monitor: {
        monitor = monitor;
        path = "/tmp/screenshot-${monitor}.png";  # Utilise la capture d'écran
        color = "rgba(25, 20, 20, 1.0)";         # Couleur de secours
        blur_size = 7;                           # Taille du flou
        blur_passes = 2;                         # Nombre de passes de flou
        noise = 0.0117;                          # Effet de bruit
        brightness = 0.8;                        # Luminosité
        vibrancy = 0.1;                          # Vibrance
        vibrancy_darkness = 0.0;
      };
    in [
      # Configuration par défaut pour tous les écrans
      {
        path = "${wallpaper}";                   # Image de secours si capture échouée
        color = "rgba(25, 20, 20, 1.0)";
        blur_size = 7;
        blur_passes = 2;
        noise = 0.0117;
        brightness = 0.8;
        vibrancy = 0.1;
        vibrancy_darkness = 0.0;
      }
    ];

    # === Champ de saisie ===
    input-field = [
      {
        size = "240, 60";                        # Taille du champ
        outline_thickness = 3;                   # Épaisseur de la bordure
        outline_color = "rgba(151, 151, 151, 1)"; # Couleur externe
        inner_color = "rgba(0, 0, 0, 0.2)";      # Couleur interne semi-transparente
        font_color = "rgba(200, 200, 200, 1)";   # Couleur du texte
        dots_size = 0.33;                        # Taille des points
        dots_spacing = 0.15;                     # Espacement entre les points
        dots_center = true;                      # Centrer les points
        fade_on_empty = true;                    # Fondu quand le champ est vide
        placeholder_text = "<i>Mot de passe...</i>"; # Texte indicatif
        hide_input = false;                      # Ne pas masquer la saisie
        position = "0, -100";                    # Position (centré, légèrement vers le haut)
        halign = "center";                       # Alignement horizontal
        valign = "center";                       # Alignement vertical
        rounding = -1;                           # Arrondi des coins (-1 = auto)
      }
    ];

    # === Labels (heure, date, user) ===
    label = [
      # Horloge ➜ rafraîchie chaque seconde
      {
        text = "$TIME";                          # Heure (variable intégrée)
        font_family = font;
        font_size = 95;                          # Grande taille pour l'horloge
        color = "rgba(242, 243, 244, 0.75)";     # Blanc semi-transparent
        position = "0, 300";                     # Position (centré, vers le bas)
        halign = "center";
        valign = "center";
      }

      # Date ➜ Utilisation d'une commande pour formater la date
      {
        text = ''cmd[update:1000] echo $(date +"%A, %d %B %Y")''; # Date avec mise à jour
        font_family = font;
        font_size = 22;
        color = "rgba(242, 243, 244, 0.75)";
        position = "0, 200";                     # Position au-dessus de l'heure
        halign = "center";
        valign = "center";
      }

      # Nom d'utilisateur
      {
        text = "$USER";                          # Nom d'utilisateur (variable intégrée)
        font_family = font;
        font_size = 25;
        color = "rgba(242, 243, 244, 0.75)";
        position = "0, 50";                      # Position en haut
        halign = "center";
        valign = "center";
      }
    ];

    # === Image de profil ===
    image = [
      {
        path = "${../../../pictures/pp_marvin_300x300.jpg}";  # Utiliser une image (optionnel)
        size = 100;                              # Taille en pixels
        position = "0, -270";                    # Position en haut
        halign = "center";
        valign = "center";
        rounding = -1;                           # Arrondi (-1 = cercle parfait)
      }
    ];
  };

  # ------------------------------------------------------------
  # 4.  Fonctions pour convertir l'attrset en texte Hyprlock
  # ------------------------------------------------------------
  mkAttrs = attrs:
    builtins.concatStringsSep ""
      (lib.mapAttrsToList (n: v:
        if builtins.isString v then "    ${n} = ${v}\n"
        else                    "    ${n} = ${toString v}\n"
      ) attrs);

  mkSection = name: value:
    if builtins.isList value then
      builtins.concatStringsSep "\n"
        (map (item: "${name} {\n${mkAttrs item}}\n") value)
    else
      "${name} {\n${mkAttrs value}}\n";

  mkConfig = cfg:
    builtins.concatStringsSep "\n"
      (lib.mapAttrsToList mkSection cfg);
in
{
  # ------------------------------------------------------------
  # 5.  Configuration du système
  # ------------------------------------------------------------
  # Ajout du script de verrouillage aux paquets
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono    # Police nécessaire
    hyprlock-blur                # Notre script de verrouillage personnalisé
    grim                         # Pour les captures d'écran
    jq                           # Pour parser la sortie JSON de hyprctl
  ];
  
  # Génération du fichier de configuration
  xdg.configFile."hypr/hyprlock.conf".text = mkConfig hyprlockConfig;

  # Configuration de Hyprland pour utiliser notre script de verrouillage
  wayland.windowManager.hyprland = {
    settings = {
      # Commandes au démarrage
      exec-once = [];  # Ne pas lancer hyprlock au démarrage
      
      # Raccourcis clavier
      bind = [
        # Super+L pour verrouiller avec capture d'écran + flou
        "SUPER, L, exec, hyprlock-blur"
        
        # Option alternative: Ctrl+Super+L pour verrouiller avec l'écran figé
        "SUPER CTRL, L, exec, hyprlock-blur"
      ];
    };
  };
}