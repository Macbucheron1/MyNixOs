{ pkgs, ... }: {
  imports = [
    # Pour l'instant, ce dossier est vide
    # Vous pourrez ajouter ici des modules pour différents environnements de développement
    # Exemple:
    # ./vscode.nix
    # ./languages.nix
  ];

  # Configuration SSH pour GitHub
  programs.ssh = {
    enable = true;
    
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}