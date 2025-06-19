 {
  description = "Flake minimal pour Acer-Aspire avec Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... } @ inputs: {
    nixosConfigurations.mac-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [
        ./hosts/mac-nixos.nix

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
