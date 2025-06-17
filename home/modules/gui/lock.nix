{ pkgs, lib, config, ... }: 

{
  # Activer Hyprlock (verrouillage d'écran pour Hyprland)
  programs.hyprlock = {
    enable = true;
    
    # Configuration du verrouillage d'écran
    settings = {
      # Configuration générale
      general = {
        disable_loading_bar = false;          # Afficher une barre de chargement
        hide_cursor = true;                   # Masquer le curseur en mode verrouillé
        grace = 0;                            # Pas de période de grâce (demande immédiatement le mot de passe)
        no_fade_in = false;                   # Animation de fondu à l'entrée
      };
      
      # Configuration du fond d'écran de verrouillage
      background = {
        path = lib.mkDefault "${../../../wallpapers/basic.png}";  # Utiliser le même fond d'écran que Hyprland
        color = "rgba(25, 20, 20, 1.0)";                         # Couleur de fond si l'image ne se charge pas
        
        # Effets visuels sur le fond d'écran
        blur_passes = 2;                      # Nombre de passes de flou (0 = pas de flou)
        blur_size = 7;                        # Taille du flou
        noise = 0.0117;                       # Effet de bruit léger
        brightness = 0.8;                     # Réduire la luminosité
        vibrancy = 0.1;                       # Légère vibrance
        vibrancy_darkness = 0.0;              # Pas d'assombrissement supplémentaire
      };
      
      # Configuration du champ de saisie
      input_field = {
        size = 200;                           # Taille du champ en pixels
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
        position = {                          # Position du champ
          x = 0;
          y = -60;
        };
      };
      
      # Texte d'horloge
      clock = {
        format = "%H:%M:%S";                  # Format de l'heure (HH:MM:SS)
        font_size = 45;                       # Taille de police
        font_family = "JetBrainsMono Nerd Font"; # Police
        color = "rgb(200, 200, 200)";         # Couleur
        position = {                          # Position
          x = 0;
          y = 210;
        };
      };
      
      # Texte de date
      date = {
        format = "%A, %d %B %Y";              # Format de date (ex: Lundi, 17 Juin 2025)
        font_size = 20;                       # Taille de police
        font_family = "JetBrainsMono Nerd Font"; # Police
        color = "rgb(200, 200, 200)";         # Couleur
        position = {                          # Position
          x = 0;
          y = 270;
        };
      };
      
      # Message de déverrouillage
      label = {
        text = "$USER";                       # Afficher le nom d'utilisateur
        color = "rgb(200, 200, 200)";         # Couleur
        font_size = 25;                       # Taille de police
        font_family = "JetBrainsMono Nerd Font"; # Police
        position = {                          # Position
          x = 0;
          y = 0;
        };
      };
    };
  };
  
  # S'assurer que la police nécessaire est installée
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
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
        # ... vos autres raccourcis existants ...
        "SUPER, L, exec, hyprlock"  # Super+L pour verrouiller l'écran
      ];
    };
  };
}