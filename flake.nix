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

    
    stylix.url        = "github:nix-community/stylix";
  };

  ##############################################################################
  # 2. OUTPUTS
  ##############################################################################
  outputs = { self, nixpkgs, home-manager, hyprland, stylix, ... } @ inputs:
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
      specialArgs = { inherit inputs hyprland stylix; };

      modules = [
        # ► tes fichiers de machine
        ./hosts/Acer-Aspire

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
          home-manager.extraSpecialArgs = { inherit hyprland stylix; };

          # charge ta config utilisateur
          home-manager.users.mac = import ./home/mac.nix;
        }
      ];
    };
  };
}
