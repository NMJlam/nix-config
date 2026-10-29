# Nix settings for every machine (NixOS and nix-darwin).
{ ... }:

{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Prebuilt binaries for the claude-code flake input (users/nlam/home/claude-code).
    extra-substituters = [ "https://claude-code.cachix.org" ];
    extra-trusted-public-keys = [
      "claude-code.cachix.org-1:YeXf2aNu7UTX8Vwrze0za1WEDS+4DuI2kVeWEE4fsRk="
    ];
  };

  # Weekly, so /nix/store doesn't grow with every rebuild.
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
}
