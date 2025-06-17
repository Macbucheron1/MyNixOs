{
  description = "Flake minimal pour Mac-NixOS avec Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    # Ajout du flake hyprlock
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      # Utiliser la même version de nixpkgs que le système
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Ajout d'agenix pour la gestion des secrets
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprlock, agenix, ... } @ inputs: {
    nixosConfigurations.mac-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/mac-nixos.nix
        # Ajout du module agenix
        agenix.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mac = import ./home/mac.nix;
        }
      ];
    };
  };
}
