{
  config,
  inputs,
  pkgs,
  ...
}:

{
  sops.secrets.tailscale-auth-key = { }; # optional: delete with the line below

  services.tailscale = {
    enable = true;
    # Stable 26.05 ships 1.98.10; 1.104.4+ fixes the Tailscale SSH bugs.
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tailscale;
    authKeyFile = config.sops.secrets.tailscale-auth-key.path; # optional: delete
    extraSetFlags = [ "--ssh" ];
    openFirewall = true;
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];
}
