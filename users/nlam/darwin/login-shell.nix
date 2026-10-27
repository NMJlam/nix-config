# Modern bash as a login shell (macOS ships 3.2). Switch once with:
#   chsh -s /run/current-system/sw/bin/bash
# The bash config itself is users/nlam/home/bash.nix.
{ pkgs, ... }:

{
  environment.shells = [ pkgs.bashInteractive ];
  environment.systemPackages = [ pkgs.bashInteractive ];
}
