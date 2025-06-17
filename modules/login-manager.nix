# Configuration du gestionnaire de connexion SDDM pour Hyprland
{ pkgs, ... }: {
  # Configuration de SDDM pour un login graphique
  services.xserver = {
    enable = true;            # Nécessaire pour le DisplayManager même en Wayland
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;  # Activer le support Wayland
        theme = "breeze";       # Utiliser un thème disponible par défaut
        settings = {
          Theme = {
            CursorTheme = "Adwaita";  # Thème de curseur standard disponible
          };
        };
      };
      # Définir Hyprland comme session par défaut
      defaultSession = "hyprland";
    };
    # Désactiver le serveur X lui-même (on utilise juste le displayManager)
    autorun = false;
  };

  # Installation des paquets nécessaires pour SDDM avec un thème adéquat
  environment.systemPackages = with pkgs; [
    libsForQt5.breeze-icons  # Thème d'icônes compatible
    libsForQt5.qt5.qtgraphicaleffects  # Pour les effets visuels dans SDDM
    libsForQt5.qt5.qtquickcontrols2     # Composants pour l'interface SDDM
    libsForQt5.qt5.qtsvg                # Support des icônes SVG
  ];

  # Configuration du clavier français au niveau système
  services.xserver.xkb.layout = "fr";
  
  # Activation de polkit nécessaire pour les autorisations en environnement graphique
  security.polkit.enable = true;
}