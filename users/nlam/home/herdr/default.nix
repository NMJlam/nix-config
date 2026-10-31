# Herdr (agent-aware tmux alternative), configured by ./config.toml.
{ inputs, pkgs, ... }:

{
  # Not in nixpkgs 26.05 yet.
  home.packages = [ inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.herdr ];
  xdg.configFile."herdr/config.toml".source = ./config.toml;
  xdg.configFile."herdr/move-pane.sh".source = ./move-pane.sh;
}
