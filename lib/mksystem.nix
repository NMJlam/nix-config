# Builds a NixOS or nix-darwin system. Each system is put together from:
#   modules/                      system config for every machine
#   machines/<name>/              config for this machine only
#   users/<user>/{nixos,darwin}/  the user's system config for this OS
#   users/<user>/home/            the user's home-manager config, the same on every machine
{ inputs }:

name:
{
  system,
  user, # folder under users/
  username ? user, # login name, passed to every module
  darwin ? false,
}:

let
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  hmModules = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc {
  specialArgs = { inherit username; };
  modules = [
    {
      nixpkgs.hostPlatform = system;
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    }

    ../modules/nix.nix
    ../machines/${name}
    ../users/${user}/${if darwin then "darwin" else "nixos"}

    hmModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      # A file home-manager doesn't manage yet (e.g. an old dotfiles config) gets renamed
      # *.hm-backup instead of stopping the switch with "would be clobbered".
      home-manager.backupFileExtension = "hm-backup";
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.${username} = import ../users/${user}/home;
    }
  ]
  ++ inputs.nixpkgs.lib.optionals darwin [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      system.primaryUser = username;
      nix-homebrew.user = username;
    }
  ];
}
