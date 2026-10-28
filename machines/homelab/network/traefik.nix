# Reverse proxy with two entry points: private (Tailscale, TLS) and public (Cloudflare Tunnel).
# Each app's router lives in that app's file; its entryPoints decide public vs private.
{ config, ... }:

let
  domain = config.homelab.domain;
in
{
  # CF_DNS_API_TOKEN for the ACME DNS challenge. A bad token only costs the real cert:
  # Traefik still starts and serves its self-signed one.
  sops.secrets.cloudflare-dns-token = { };
  sops.templates."traefik.env" = {
    content = "CF_DNS_API_TOKEN=${config.sops.placeholder.cloudflare-dns-token}";
    restartUnits = [ "traefik.service" ];
  };

  services.traefik = {
    enable = true;
    environmentFiles = [ config.sops.templates."traefik.env".path ];

    staticConfigOptions = {
      entryPoints = {
        private = {
          address = ":443";
          # One wildcard cert, so CT logs show *.home.<domain> instead of each app's name.
          http.tls = {
            certResolver = "cloudflare";
            domains = [
              {
                main = "home.${domain}";
                sans = [ "*.home.${domain}" ];
              }
            ];
          };
        };
        public = {
          # Loopback only: cloudflared runs on this machine; nothing outside can reach it.
          address = "127.0.0.1:8080";
          forwardedHeaders.trustedIPs = [ "127.0.0.1/32" ];
        };
      };

      certificatesResolvers.cloudflare.acme = {
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge.provider = "cloudflare";
      };
    };
  };
}
