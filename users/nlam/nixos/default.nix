# nlam on NixOS (the homelab).
{ username, ... }:

{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker" # root-equivalent; fine on a single-user box
    ];
  };
}
