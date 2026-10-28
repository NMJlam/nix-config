# Test app that echoes the request back: whoami.home.<domain> over Tailscale,
# whoami.<domain> via Cloudflare. Delete once real apps work.
{ config, pkgs, ... }:

let
  domain = config.homelab.domain;
in
{
  systemd.services.whoami = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.whoami}/bin/whoami -port 8000"; # port 8000 stays closed in the firewall
      DynamicUser = true;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.whoami-private = {
      rule = "Host(`whoami.home.${domain}`)";
      entryPoints = [ "private" ];
      service = "whoami";
    };
    routers.whoami-public = {
      rule = "Host(`whoami.${domain}`)";
      entryPoints = [ "public" ];
      service = "whoami";
    };
    services.whoami.loadBalancer.servers = [ { url = "http://127.0.0.1:8000"; } ];
  };
}
