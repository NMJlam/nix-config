# Public access through a token-based (remotely managed) tunnel. The token in secrets.yaml holds
# the tunnel ID, so the ID never appears in this repo. The tunnel's one ingress rule lives in the
# Cloudflare dashboard: *.<domain> -> http://127.0.0.1:8080 (Traefik's public entry point).
# DNS decides which hostnames reach the tunnel (one proxied CNAME per public subdomain).
{ config, pkgs, ... }:

{
  sops.secrets.cloudflared-token.restartUnits = [ "cloudflared.service" ];

  # Not nixpkgs' services.cloudflared: it needs the tunnel ID in Nix.
  systemd.services.cloudflared = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token-file %d/token";
      LoadCredential = "token:${config.sops.secrets.cloudflared-token.path}";
      DynamicUser = true;
      Restart = "on-failure";
    };
  };
}
