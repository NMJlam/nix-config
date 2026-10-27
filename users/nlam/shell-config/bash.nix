# Ported from the old ~/.zshrc / ~/.bash_profile. Mac-only bits sit behind isDarwin.
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

  # Vi mode, 100ms escape timeout, Ghostty's Ctrl+[ (CSI-u) -> normal mode.
  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
      keyseq-timeout = 100;
    };
    extraConfig = ''
      # Cursor shape per vi mode: block in normal mode, bar in insert mode.
      # \1 and \2 mark the escape codes as invisible so the prompt width stays right.
      set show-mode-in-prompt on
      set vi-cmd-mode-string "\1\e[2 q\2"
      set vi-ins-mode-string "\1\e[6 q\2"

      set keymap vi-insert
      "\e[91;5u": vi-movement-mode
      # vi-insert has no Ctrl-L by default (only vi-command does).
      "\C-l": clear-screen
    '';
  };

  # Config is users/nlam/starship.toml (linked in home-manager.nix).
  programs.starship.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  # Shell wrapper: quitting yazi leaves the shell in the last browsed directory.
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    shellWrapperName = "y";
  };
}
