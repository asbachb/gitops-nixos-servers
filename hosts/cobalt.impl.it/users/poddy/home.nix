{ pkgs, inputs, ...}:
{
    home-manager.users.poddy = {
    home = {
      packages = [
        pkgs.htop
      ];
      stateVersion = "25.11";
    };
    
    imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

    virtualisation.quadlet.containers = {
      echo-server = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
        };
        containerConfig = {
          image = "docker.io/mendhak/http-https-echo:31";
          publishPorts = [ "127.0.0.1:8080:8080" ];
          userns = "keep-id";
        };
      };
    };
  };
}