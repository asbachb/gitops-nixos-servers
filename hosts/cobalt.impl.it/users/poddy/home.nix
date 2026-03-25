{ pkgs, inputs, ...}:
let
in
{
    home-manager.users.poddy = {
    home = {
      stateVersion = "25.11";
    };

    imports = [
      inputs.quadlet-nix.homeManagerModules.quadlet
      "./containers/caddy/container.nix"
    ];
  };
}