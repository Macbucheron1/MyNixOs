{ pkgs, lib, config, inputs, ... }: 

{
  # Nous n'activons pas le module hyprlock intégré à Home Manager pour éviter les collisions
  # Nous utilisons uniquement le binaire du flake et configurons manuellement
  xdg.configFile."hypr/hyprlock.conf".text = ''
    # Configuration générale
    general {
      disable_loading_bar = false
      hide_cursor = true
      grace = 0
      no_fade_in = false
    }
    
    # Configuration du fond d'écran de verrouillage
    background {
      path = ${lib.escapeShellArg "${../../../wallpapers/basic.png}"}
      color = rgba(25, 20, 20, 1.0)
      
      # Effets visuels sur le fond d'écran
      blur_passes = 2
      blur_size = 7
      noise = 0.0117
      brightness = 0.8
      vibrancy = 0.1
      vibrancy_darkness = 0.0
    }
    
    # Configuration du champ de saisie
    input-field {
      size = 200
      outline_thickness = 3
      dots_size = 0.33
      dots_spacing = 0.15
      dots_center = true
      outer_color = rgb(151, 151, 151)
      inner_color = rgb(200, 200, 200)
      font_color = rgb(10, 10, 10)
      fade_on_empty = true
      placeholder_text = <i>Mot de passe...</i>
      hide_input = false
      position = 0, -60
    }
    
    # Texte d'horloge
    clock {
      format = %H:%M:%S
      font_size = 45
      font_family = JetBrainsMono Nerd Font
      color = rgb(200, 200, 200)
      position = 0, 210
    }
    
    # Texte de date
    date {
      format = %A, %d %B %Y
      font_size = 20
      font_family = JetBrainsMono Nerd Font
      color = rgb(200, 200, 200)
      position = 0, 270
    }
    
    # Message de déverrouillage
    label {
      text = $USER
      color = rgb(200, 200, 200)
      font_size = 25
      font_family = JetBrainsMono Nerd Font
      position = 0, 0
    }
  '';
  
  # S'assurer que les dépendances nécessaires sont installées
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    # Nous n'installons PAS hyprlock ici car il est déjà installé au niveau système
    # et provoquerait une collision
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