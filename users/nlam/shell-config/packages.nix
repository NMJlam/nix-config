# Terminal tools installed on every machine. fzf, starship, tmux and zoxide come from their programs.* modules.
{ lib, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Latest Claude Code from the claude-code flake input (see flake.nix).
    inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code

    _7zz
    btop
    cmake
    cmatrix
    eza
    fd
    ffmpeg
    gh
    go
    imagemagick
    jq
    just
    lavat
    lazygit
    lsd
    neovim
    nmap
    poppler-utils
    rustup
    tldr
    tree-sitter
    uv
    vim
    wget
  ]
  # The Mac gets bun from Homebrew instead (machines/macbook.nix): the bun-installed
  # omp in ~/.bun/bin needs a newer bun than nixpkgs 26.05 ships.
  ++ lib.optionals (!pkgs.stdenv.isDarwin) [ bun ]
  ++ lib.optionals pkgs.stdenv.isDarwin [ nodejs ];
}
