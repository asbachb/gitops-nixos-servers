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
  in {
      containers.caddy.containerConfig.image = builds.caddy.ref;
      builds.caddy.buildConfig.file = containerfile.outPath;
  };
}