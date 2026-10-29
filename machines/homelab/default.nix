# Minisforum homelab
{ inputs, pkgs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware.nix
    ./homelab.nix
    ./network/traefik.nix
    ./network/tailscale.nix
    ./network/cloudflared.nix
    ./apps/whoami.nix
  ];

  # Encrypted to the keys in /.sops.yaml; decrypted at activation with this machine's SSH host key.
  # Edit with `sops machines/homelab/secrets.yaml`.
  sops.defaultSopsFile = ./secrets.yaml;

  networking.hostName = "homelab";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Still needed: sops-nix decrypts with its ed25519 host key. Logins go through Tailscale SSH,
  # so port 22 stays closed on the LAN.
  services.openssh.enable = true;
  services.openssh.openFirewall = false;

  environment.systemPackages = [
    pkgs.git
    # So TERM=xterm-ghostty works when SSHing in from Ghostty on the Mac.
    pkgs.ghostty.terminfo
  ];

  system.stateVersion = "26.05";
}
