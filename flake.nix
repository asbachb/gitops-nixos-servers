{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs =
    {
      nixpkgs,
      disko,
      quadlet-nix,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations."cobalt.impl.it" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          ./disk-layouts/gpt-btrfs-with-subvolumes.nix
          ./netcup-vserver/hardware.nix
          ./hosts/cobalt.impl.it/configuration.nix

          home-manager.nixosModules.home-manager
          quadlet-nix.nixosModules.quadlet
        ];
      };
    };
}
