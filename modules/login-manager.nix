{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Installation des paquets nécessaires
  environment.systemPackages = with pkgs; [
    greetd.tuigreet
    # Utilisation du paquet hyprlock depuis le flake dédié
    # (le paquet n'est pas dans nixpkgs stable)
  ];

  # Configuration de greetd avec autologin
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Script pour l'autologin suivi du lancement immédiat de Hyprland
        command = pkgs.writeShellScript "hyprland-with-lock" ''
          # Export des variables d'environnement nécessaires
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=Hyprland
          export XDG_CURRENT_DESKTOP=Hyprland
          
          # Lancer Hyprland immédiatement (hyprlock sera lancé par la config de Hyprland)
          exec Hyprland
        '';
        # Utilisateur qui sera connecté automatiquement
        user = "mac";
      };
    };
  };
  
  # Configuration PAM nécessaire pour hyprlock
  security.pam.services.hyprlock = {};
  
  # Configuration du trousseau GNOME pour éviter la double saisie de mot de passe
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;
}