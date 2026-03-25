{ pkgs, inputs, ...}:
let
  echo-server = import ./containers/echo-server/container.nix;
  echo-server2 = import ./containers/echo-server2/container.nix;
in
{
    home-manager.users.poddy = {
    home = {
      packages = [
        #pkgs.htop
      ];
      stateVersion = "25.11";
    };
    
    imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

    virtualisation.quadlet.containers = echo-server // echo-server2;
  };
}