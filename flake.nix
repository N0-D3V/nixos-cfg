{
  description = "Nodev's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    illogical-flake = {
      url = "path:flakes/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      illogical-flake,
      ...
    }@inputs:
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./packages.nix
          ./services.nix
          ./system.nix
          ./hardware-configuration.nix
          ./boot.nix
          ./user.nix
          ./laptop.nix

          inputs.spicetify-nix.nixosModules.spicetify
        ];
      };

      homeConfigurations."nodev" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs;
        };
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          illogical-flake.homeManagerModules.default
          ./home.nix
        ];
      };

    };
}
