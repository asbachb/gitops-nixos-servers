{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
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
      sops-nix,
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

          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          quadlet-nix.nixosModules.quadlet
        ];
      };
    };
}
