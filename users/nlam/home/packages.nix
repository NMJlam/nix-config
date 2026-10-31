# Terminal tools installed on every machine. Tools with config of their own live in
# their own module (claude-code/, herdr/, neovim.nix, starship/, tmux.nix; zoxide/fzf/yazi in bash.nix).
{ lib, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      _7zz
      btop
      cmake
      cmatrix
      fd
      ffmpeg
      gh
      go
      imagemagick
      jq
      just
      lavat
      lazygit
      neovim
      nmap
      poppler-utils
      rustup
      sops # edits machines/homelab/secrets.yaml
      tldr
      tree-sitter
      uv
      vim
      wget
    ]
    # The Mac gets bun from Homebrew instead (users/nlam/darwin/homebrew.nix): the bun-installed
    # omp in ~/.bun/bin needs a newer bun than nixpkgs 26.05 ships.
    ++ lib.optionals (!pkgs.stdenv.isDarwin) [ bun ]
    ++ lib.optionals pkgs.stdenv.isDarwin [ nodejs ];
}
