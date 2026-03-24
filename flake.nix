{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      nixpkgs,
      disko,
      ...
    }:
    {
      nixosConfigurations."cobalt.impl.it" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./netcup-vserver/disk.nix
          ./netcup-vserver/hardware.nix
          ./hosts/cobalt.impl.it/configuration.nix
        ];
      };
    };
}
