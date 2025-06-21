{
  description = "NixOS configuration for Acer-Aspire with Home-Manager";

  ##############################################################################
  # 1. INPUTS
  ##############################################################################
  inputs = {
    # Nixpkgs : canal 25.05
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    # Home-Manager aligné sur le même nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland (flake officiel)
    hyprland.url = "github:hyprwm/Hyprland";

    # Catppuccin : thème complet (GTK, curseurs, Starship…)
    catppuccin.url = "github:catppuccin/nix";
  };

  ##############################################################################
  # 2. OUTPUTS
  ##############################################################################
  outputs = { self, nixpkgs, home-manager, hyprland, catppuccin, ... } @ inputs:
  let
    system = "x86_64-linux";
  in
  {
    ########################################################################
    # 2-a. Configuration NixOS (avec Home-Manager intégré)
    ########################################################################
    nixosConfigurations."Acer-Aspire" = nixpkgs.lib.nixosSystem {
      inherit system;

      # transmet tous les inputs aux modules si besoin
      specialArgs = { inherit inputs hyprland catppuccin; };

      modules = [
        # ► tes fichiers de machine
        ./hosts/Acer-Aspire

        # ► module NixOS Catppuccin (console, plymouth, etc.)
        catppuccin.nixosModules.catppuccin

        # ► module NixOS fourni par la flake Hyprland
        hyprland.nixosModules.default

        # ► Home-Manager intégré au système
        home-manager.nixosModules.home-manager

        # ──────────────────────────────────────────────────────────────
        #  bloc de configuration Home-Manager pour l'utilisateur 'mac'
        # ──────────────────────────────────────────────────────────────
        {
          # paquets système = pkgs, paquets utilisateurs = pkgs
          home-manager.useGlobalPkgs   = true;
          home-manager.useUserPackages = true;

          # passe catppuccin et hyprland aux modules Home-Manager
          home-manager.extraSpecialArgs = { inherit hyprland catppuccin; };

          # charge ta config utilisateur
          home-manager.users.mac = import ./home/mac.nix;
        }
      ];
    };

    ########################################################################
    # 2-b. (optionnel) Home-Manager autonome
    ########################################################################
    # Utile si tu veux déployer *uniquement* la partie HM sur une autre
    # distribution ou dans un conteneur. Tu peux supprimer ce bloc si tu
    # n’en as pas besoin.
    homeConfigurations."mac" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};

      extraSpecialArgs = { inherit hyprland catppuccin; };

      modules = [
        ./home/mac.nix
        catppuccin.homeModules.catppuccin
      ];
    };
  };
}
