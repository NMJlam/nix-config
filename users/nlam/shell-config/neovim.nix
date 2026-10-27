# NvChad config from github, plus the tools it expects on PATH (it doesn't use mason).
{ lib, pkgs, ... }:

{
  # Cloned, not symlinked from the store: lazy.nvim writes lazy-lock.json and you push changes from here.
  # Only runs when ~/.config/nvim is missing; updates are a normal `git pull`.
  home.activation.cloneNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.config/nvim" ]; then
      run ${pkgs.git}/bin/git clone https://github.com/NMJlam/nvim-config.git "$HOME/.config/nvim" \
        || warnEcho "nvim-config clone failed; rerun the switch once online"
    fi
  '';

  home.packages =
    with pkgs;
    [
      ripgrep # telescope live_grep

      # LSPs enabled in lua/configs/lspconfig.lua
      clang-tools # clangd + clang-format
      lua-language-server
      neocmakelsp
      nixd
      pyright

      # formatters from lua/configs/conform.lua
      gofumpt
      nixfmt
      prettier
      ruff
      stylua
    ]
    # treesitter compiles parsers; macOS already has cc from the Xcode CLT
    ++ lib.optionals stdenv.isLinux [ gcc ];
}
