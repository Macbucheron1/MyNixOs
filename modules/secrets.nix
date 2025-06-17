{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  # Installation de l'outil agenix
  environment.systemPackages = [ inputs.agenix.packages.${pkgs.system}.default ];

  # Configuration principale d'agenix
  age = {
    # Chemin vers votre clé SSH privée qui pourra déchiffrer les secrets
    identityPaths = [
      "/home/mac/.ssh/id_ed25519"
    ];
    
    # La définition des secrets sera ajoutée ici au fur et à mesure
    # de vos besoins. Les secrets peuvent être référencés dans d'autres
    # modules via config.age.secrets.<nom>.path
    secrets = {
      # Vous ajouterez vos secrets ici selon vos besoins
    };
  };
}