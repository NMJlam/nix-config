# Ported from the old ~/.zshrc / ~/.bash_profile. Mac-only bits sit behind isDarwin.
# Input (vi mode) is readline.nix, the prompt is starship/.
{ lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # neovim itself is installed via packages.nix.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  }
  // lib.optionalAttrs isDarwin {
    BUN_INSTALL = "$HOME/.bun";
  };

  # First entry ends up first on PATH.
  home.sessionPath = [
    "$HOME/.local/bin"
  ]
  ++ lib.optionals isDarwin [
    "$HOME/.orbstack/bin"
    "$HOME/.bun/bin"
    "/Applications/Ghostty.app/Contents/MacOS"
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      yy = "yazi";
      cd = "z";
    }
    // lib.optionalAttrs isDarwin {
      nv-config = "nvim ~/.config/nvim/lua/plugins/init.lua";
    };
    profileExtra = ''
      # cargo install binaries; appended so nix's rustup wins over old copies in ~/.cargo/bin
      export PATH="$PATH:$HOME/.cargo/bin"
    '';
    initExtra = lib.mkAfter ''
      command -v omp >/dev/null && eval "$(omp completions bash)"
    '';
  };

  # Tools that hook into bash.
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  # Shell wrapper: quitting yazi leaves the shell in the last browsed directory.
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
  };
}
