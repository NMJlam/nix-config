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

  services.openssh.enable = true;

  environment.systemPackages = [
    pkgs.git
    # So TERM=xterm-ghostty works when SSHing in from Ghostty on the Mac.
    pkgs.ghostty.terminfo
  ];

  system.stateVersion = "26.05";
}
