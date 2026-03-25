{ pkgs, inputs, ...}:
let
  echo-server = import ./containers/echo-server/container.nix;
in
{
    home-manager.users.poddy = {
    home = {
      packages = [
        pkgs.htop
      ];
      stateVersion = "25.11";
    };
    
    imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

    virtualisation.quadlet.containers = echo-server;
  };
}