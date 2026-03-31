{ config, pkgs, ... }:
{
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) builds;
    caddyVersion = "2.10.2";
    containerfile = pkgs.writeText "Containerfile" ''
      FROM docker.io/caddy:${caddyVersion}-builder AS builder

      RUN xcaddy build \
          --with github.com/caddy-dns/cloudflare@v0.2.2 \
          --with github.com/lucaslorentz/caddy-docker-proxy@v2.10.0

      FROM docker.io/caddy:${caddyVersion}

      COPY --from=builder /usr/bin/caddy /usr/bin/caddy

      CMD ["caddy", "docker-proxy"]
    '';
    caddyfile = pkgs.writeText "Caddyfile" ''
      {
        debug
        acme_dns cloudflare -RWpib-iOXuhHFSyY00PtStblzxXpf5BzDVCETYj
      }

      impl.it {
          respond "impl.it"
      }
    '';
  in {
      builds.caddy.buildConfig.file = containerfile.outPath;
      volumes.caddy-data = {};
      containers.caddy = {
        containerConfig = {
          image = builds.caddy.ref;
          volumes = [
            "caddy-data.volume:/data:Z"
            "${caddyfile.outPath}:/etc/caddy/Caddyfile:Z"
            "%t/podman/podman.sock:/var/run/docker.sock"
          ];
          environments = {
            CADDY_DOCKER_NO_SCOPE = "true";
            CADDY_DOCKER_CADDYFILE_PATH = "/etc/caddy/Caddyfile";
          };
          publishPorts = [
            "80:80"
            "443:443"
            "443:443/udp"
          ];
        };
      };
  };
}
