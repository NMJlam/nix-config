# home-manager config shared by every machine (MacBook and homelab).
# Mac-only home files live with their tool in ../darwin/.
{ ... }:

{
  imports = [
    ./bash.nix
    ./claude-code
    ./herdr
    ./neovim.nix
    ./packages.nix
    ./readline.nix
    ./starship
    ./tmux.nix
  ];

  home.stateVersion = "24.05";
}
