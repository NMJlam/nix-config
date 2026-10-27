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
