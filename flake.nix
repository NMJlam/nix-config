{
  inputs = {
    # One nixpkgs for every machine; nix-darwin and home-manager use the matching release branches.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Claude Code tracks npm releases within the hour; nixpkgs stable lags behind.
    # Not following our nixpkgs so the claude-code.cachix.org binaries still match.
    claude-code.url = "github:sadjow/claude-code-nix";

    # Installs Homebrew itself on the MacBook (nix-darwin's homebrew.* only manages packages).
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkSystem = import ./lib/mksystem.nix { inherit inputs; };
    in
    {
      nixosConfigurations.homelab = mkSystem "homelab" {
        system = "x86_64-linux";
        user = "nlam";
      };

      darwinConfigurations.macbook = mkSystem "macbook" {
        system = "aarch64-darwin";
        user = "nlam";
        darwin = true;
      };

      # `nix fmt`
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    };
}
