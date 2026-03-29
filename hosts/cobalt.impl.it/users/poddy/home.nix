{ pkgs, inputs, ...}:
{
  home = {
    stateVersion = "25.11";
  };

  imports = [
    inputs.quadlet-nix.homeManagerModules.quadlet
    ./containers/caddy/container.nix
  ];
}