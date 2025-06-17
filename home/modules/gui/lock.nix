{ pkgs, lib, config, inputs, ... }: 

let
  # ------------------------------------------------------------
  # 1.  Variables de confort
  # ------------------------------------------------------------
  wallpaper = ../../../wallpapers/basic.png;      # Chemin vers le fond d'écran
  profilePic = ../../../pictures/pp_marvin_300x300.jpg; # Photo de profil
  font      = "JetBrainsMono Nerd Font";

  # ------------------------------------------------------------
  # 2.  Définition de la conf Hyprlock sous forme d'attrset
  #     (c'est plus facile à maintenir et à templater)
  # ------------------------------------------------------------
  hyprlockConfig = {
    # === Bloc global ===
    general = {
      disable_loading_bar = false;          # Afficher une barre de chargement
      hide_cursor = true;                   # Masquer le curseur en mode verrouillé
      grace       = 0;                      # Pas de période de grâce (demande immédiatement le mot de passe)
      no_fade_in  = false;                  # Animation de fondu à l'entrée
    };

    # === Fond d'écran + effets ===
    background = [
      {
        path           = "${wallpaper}";
        color          = "rgba(25, 20, 20, 1.0)";  # Couleur de fond si l'image ne se charge pas
        blur_size      = 7;                        # Taille du flou
        blur_passes    = 2;                        # Nombre de passes de flou (0 = pas de flou)
        noise          = 0.0117;                   # Effet de bruit léger
        brightness     = 0.8;                      # Réduire la luminosité
        vibrancy       = 0.1;                      # Légère vibrance
        vibrancy_darkness = 0.0;                   # Pas d'assombrissement supplémentaire
      }
    ];

    # === Champ de saisie ===
    input-field = [
      {
        size              = "200, 50";            # Taille du champ en pixels
        outline_thickness = 3;                    # Épaisseur de la bordure
        outline_color     = "rgb(151, 151, 151)"; # Couleur externe
        inner_color       = "rgb(200, 200, 200)"; # Couleur interne
        font_color        = "rgb(10, 10, 10)";    # Couleur de texte
        dots_size         = 0.33;                 # Taille des points (caractères masqués)
        dots_spacing      = 0.15;                 # Espacement entre les points
        dots_center       = true;                 # Centrer les points
        fade_on_empty     = true;                 # Fondu quand le champ est vide
        placeholder_text  = "<i>Mot de passe…</i>"; # Texte indicatif
        hide_input        = false;                # Ne pas masquer la saisie
        position          = "0, -60";             # Position du champ
      }
    ];

    # === Image de profil ===
    image = [
      {
        path = "${profilePic}";             # Utiliser l'image de profil Marvin
        size = 100;                         # Taille en pixels
        position = "0, -270";               # Position en haut
        halign = "center";                  # Alignement horizontal centré
        valign = "center";                  # Alignement vertical centré
        rounding = -1;                      # Arrondi (-1 = cercle parfait)
      }
    ];

    # === Labels (heure, date, user) ===
    label = [
      # Horloge ➜ rafraîchie chaque seconde
      {
        text        = "{time:%H:%M:%S}";
        font_family = font;
        font_size   = 45;
        color       = "rgb(200, 200, 200)";
        position    = "0, 210";
      }

      # Date ➜ rafraîchie toutes les ~10 secondes automatiquement
      {
        text        = "{date:%A, %d %B %Y}";
        font_family = font;
        font_size   = 20;
        color       = "rgb(200, 200, 200)";
        position    = "0, 270";
      }

      # Nom d'utilisateur
      {
        text        = "$USER";
        font_family = font;
        font_size   = 25;
        color       = "rgb(200, 200, 200)";
        position    = "0, 0";
      }
    ];
  };

  # ------------------------------------------------------------
  # 3.  Fonctions pour convertir l'attrset en texte Hyprlock
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
  # 4.  Écriture du fichier dans ~/.config/hypr/hyprlock.conf
  # ------------------------------------------------------------
  xdg.configFile."hypr/hyprlock.conf".text = mkConfig hyprlockConfig;

  # Police nécessaire (hyprlock ne la charge pas tout seul)
  home.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  
  # Configuration de Hyprland pour utiliser Hyprlock au démarrage
  wayland.windowManager.hyprland = {
    settings = {
      # Commande à exécuter au démarrage de Hyprland
      exec-once = [
        "hyprlock"  # Lancer Hyprlock immédiatement au démarrage
      ];
      
      # Raccourci clavier pour verrouiller l'écran
      bind = [
        # Super+L pour verrouiller l'écran
        "SUPER, L, exec, hyprlock"
      ];
    };
  };
}