{
  modulesPath,
  lib,
  pkgs,
  inputs,
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

    hostName = "cobalt";
    domain = "impl.it";

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
      openssh.authorizedKeys.keys = [
        sshKey
        "command=\"sudo nixos-rebuild switch --flake github:asbachb/gitops-nixos-servers#cobalt.impl.it --refresh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICm/IvGQDhfZ5+6dsf2KbA6I5hE0JHaiKhMef3xjitjI"
      ];
    };
    poddy = {
      isNormalUser  = true;
      home  = "/home/poddy";
      openssh.authorizedKeys.keys = [ sshKey ];
      linger = true;
      autoSubUidGidRange = true;
    };
  };
  security.sudo.extraRules = [
    {
      users = [ "chemist" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  security.pam.sshAgentAuth.enable = true;

  virtualisation = {
    podman.enable = true;
    quadlet.enable = true;
  };

  home-manager.extraSpecialArgs = { inherit inputs; };

  system.stateVersion = "25.11";
}
