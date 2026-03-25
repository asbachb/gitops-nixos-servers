{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
let
  sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDlmq88kU7BwsIQCJ/l48FY5GZk7wjOjo6+HDHGOMXS9";
in
{
  boot.loader = {
    systemd-boot.enable = true;
    timeout = 3;
  };

  nix.settings = {
    substituters = [ "https://aseipp-nix-cache.freetls.fastly.net" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  networking = {
    useDHCP = false;

    interfaces.ens3 = {
      # IPv4
      ipv4.addresses = [{
        address = "159.195.67.194";
        prefixLength = 22;
      }];

      # IPv6
      ipv6.addresses = [{
        address = "2a0a:4cc0:c2:1e81:a87d:3dff:fea5:9561";
        prefixLength = 64;
      }];
    };

    defaultGateway = {
      address = "159.195.64.1";
      interface = "ens3";
    };

    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };

  users.users = {
    root.openssh.authorizedKeys.keys = [ sshKey ];
    chemist = {
      isNormalUser  = true;
      home  = "/home/chemist";
      extraGroups  = [ "wheel"  ];
      openssh.authorizedKeys.keys = [ sshKey ];
    };
    poddy = {
      isNormalUser  = true;
      home  = "/home/poddy";
      openssh.authorizedKeys.keys = [ sshKey ];
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  security.pam.sshAgentAuth.enable = true;

  virtualisation.podman.enable = true;

  system.stateVersion = "25.11";
}
