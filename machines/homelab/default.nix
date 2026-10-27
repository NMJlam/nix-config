# Minisforum homelab
{ pkgs, ... }:

{
  imports = [ ./hardware.nix ];

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
