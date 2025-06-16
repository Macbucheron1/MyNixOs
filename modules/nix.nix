{ config, pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Configuration du garbage collector
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimisations de stockage
  nix.settings.auto-optimise-store = true;
  
  # Empêcher la suppression des générations actuelles et précédentes
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;
  
  # Alias pour les commandes de nettoyage manuel
  environment.shellAliases = {
    nix-clean = "nix-collect-garbage -d";
    nix-clean-all = "sudo nix-collect-garbage -d";
  };
}
