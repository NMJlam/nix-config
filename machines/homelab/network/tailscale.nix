# Private access from my devices. Joins the tailnet on its own with the auth key from secrets.yaml
# (a reusable, pre-approved key from the Tailscale admin console).
{ config, ... }:

{
  sops.secrets.tailscale-auth-key = { };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    # Tailscale SSH: `ssh homelab` from any tailnet device, authenticated by tailnet identity,
    # so no SSH keys or ~/.ssh/config entries (MagicDNS resolves the hostname).
    extraSetFlags = [ "--ssh" ];
    openFirewall = true; # UDP 41641, so devices connect directly instead of through relays
  };

  # Traefik's private entry point, reachable over the tailnet only.
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];
}
