{ pkgs, lib, config, inputs, ... }: 

{
  # Nous utilisons le module xdg.configFile pour stocker la configuration dans un format Nix
  xdg.configFile."hypr/hyprlock.conf".text = let
    # Configuration hyprlock en format Nix
    hyprlock_config = {
      # Configuration générale
      general = {
        disable_loading_bar = false;          # Afficher une barre de chargement
        hide_cursor = true;                   # Masquer le curseur en mode verrouillé
        grace = 0;                            # Pas de période de grâce (demande immédiatement le mot de passe)
        no_fade_in = false;                   # Animation de fondu à l'entrée
      };
      
      # Configuration du fond d'écran de verrouillage
      background = [
        {
          path = "${../../../wallpapers/basic.png}";  # Utiliser le même fond d'écran que Hyprland
          color = "rgba(25, 20, 20, 1.0)";           # Couleur de fond si l'image ne se charge pas
          
          # Effets visuels sur le fond d'écran
          blur_passes = 2;                      # Nombre de passes de flou (0 = pas de flou)
          blur_size = 7;                        # Taille du flou
          noise = 0.0117;                       # Effet de bruit léger
          brightness = 0.8;                     # Réduire la luminosité
          vibrancy = 0.1;                       # Légère vibrance
          vibrancy_darkness = 0.0;              # Pas d'assombrissement supplémentaire
        }
      ];
      
      # Configuration du champ de saisie
      input-field = [
        {
          size = "200, 50";                     # Taille du champ en pixels
          outline_thickness = 3;                # Épaisseur de la bordure
          dots_size = 0.33;                     # Taille des points (caractères masqués)
          dots_spacing = 0.15;                  # Espacement entre les points
          dots_center = true;                   # Centrer les points
          outer_color = "rgb(151, 151, 151)";   # Couleur externe
          inner_color = "rgb(200, 200, 200)";   # Couleur interne
          font_color = "rgb(10, 10, 10)";       # Couleur de texte
          fade_on_empty = true;                 # Fondu quand le champ est vide
          placeholder_text = "<i>Mot de passe...</i>"; # Texte indicatif
          hide_input = false;                   # Ne pas masquer la saisie
          position = "0, -60";                  # Position du champ
        }
      ];
      
      # Texte d'horloge
      clock = [
        {
          format = "%H:%M:%S";                  # Format de l'heure (HH:MM:SS)
          font_size = 45;                       # Taille de police
          font_family = "JetBrainsMono Nerd Font"; # Police
          color = "rgb(200, 200, 200)";         # Couleur
          position = "0, 210";                  # Position
        }
      ];
      
      # Texte de date
      date = [
        {
          format = "%A, %d %B %Y";              # Format de date (ex: Lundi, 17 Juin 2025)
          font_size = 20;                       # Taille de police
          font_family = "JetBrainsMono Nerd Font"; # Police
          color = "rgb(200, 200, 200)";         # Couleur
          position = "0, 270";                  # Position
        }
      ];
      
      # Message de déverrouillage
      label = [
        {
          text = "$USER";                       # Afficher le nom d'utilisateur
          color = "rgb(200, 200, 200)";         # Couleur
          font_size = 25;                       # Taille de police
          font_family = "JetBrainsMono Nerd Font"; # Police
          position = "0, 0";                    # Position
        }
      ];
    };

    # Fonction pour transformer notre configuration Nix en format texte pour hyprlock
    mkConfig = config:
      let
        # Fonction pour formater une section de configuration
        mkSection = name: value:
          if builtins.isAttrs value then
            "${name} {\n${mkAttrs value}}\n"
          else if builtins.isList value then
            builtins.concatStringsSep "\n" (map (item: "${name} {\n${mkAttrs item}}\n") value)
          else
            "${name} = ${toString value}\n";

        # Fonction pour formater les attributs d'une section
        mkAttrs = attrs:
          builtins.concatStringsSep "" (lib.mapAttrsToList 
            (name: value: 
              if builtins.isString value then
                "    ${name} = ${value}\n"
              else
                "    ${name} = ${toString value}\n"
            ) 
            attrs
          );
      in
        builtins.concatStringsSep "\n" (lib.mapAttrsToList mkSection config);

  in mkConfig hyprlock_config;
  
  # S'assurer que les dépendances nécessaires sont installées
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    # Nous n'installons PAS hyprlock ici car il est déjà installé au niveau système
  ];

  # Configuration de Hyprland pour utiliser Hyprlock au démarrage
  wayland.windowManager.hyprland = {
    settings = {
      # Commande à exécuter au démarrage de Hyprland
      exec-once = [
        "hyprlock"  # Lancer Hyprlock immédiatement au démarrage
      ];
      
      # Raccourci clavier pour verrouiller l'écran
      bind = [
        # Ne pas modifier les raccourcis existants, juste ajouter le nouveau
        "SUPER, L, exec, hyprlock"  # Super+L pour verrouiller l'écran
      ];
    };
  };
}