# nlam on NixOS (the homelab).
{ ... }:

{
  users.users.nlam = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
}
