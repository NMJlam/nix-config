# Builds a NixOS or nix-darwin system from machines/<name>.nix and users/<user>/.
{ inputs }:

name:
{
  system,
  user,
  darwin ? false,
}:

let
  systemFunc = if darwin then inputs.nix-darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
  hmModules = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in
systemFunc {
  modules = [
    {
      nixpkgs.hostPlatform = system;
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Prebuilt binaries for the claude-code flake input.
      nix.settings.extra-substituters = [ "https://claude-code.cachix.org" ];
      nix.settings.extra-trusted-public-keys = [
        "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
      ];
    }

    ../machines/${name}.nix
    ../users/${user}/${if darwin then "darwin" else "nixos"}.nix

    (if darwin then { system.primaryUser = user; } else { })
    (if darwin then inputs.nix-homebrew.darwinModules.nix-homebrew else { })
    (if darwin then { nix-homebrew.user = user; } else { })

    hmModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      # A file home-manager doesn't manage yet (e.g. an old dotfiles config) gets renamed
      # *.hm-backup instead of stopping the switch with "would be clobbered".
      home-manager.backupFileExtension = "hm-backup";
      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.users.${user} = import ../users/${user}/home-manager.nix;
    }
  ];

}
