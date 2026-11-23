# changedetection.io: watches web pages for changes. changes.<domain> over Tailscale only,
# because the app has no login by default. Watches live in /var/lib/changedetection-io, not here.
{ config, lib, ... }:

let
  domain = config.homelab.domain;
in
{
  # nixpkgs marks it unfree; allow only this package.
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "changedetection-io";

  services.changedetection-io = {
    enable = true;
    listenAddress = "127.0.0.1"; # port 5000 stays closed in the firewall
    behindProxy = true;
    baseURL = "https://changes.${domain}";
    # Headless Chromium in a container on 127.0.0.1:4444, for pages that render with JavaScript.
    playwrightSupport = true;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.changedetection = {
      rule = "Host(`changes.${domain}`)";
      entryPoints = [ "private" ];
      service = "changedetection";
    };
    services.changedetection.loadBalancer.servers = [ { url = "http://127.0.0.1:5000"; } ];
  };
}
