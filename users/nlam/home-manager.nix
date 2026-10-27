{ lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./shell-config/bash.nix
    ./shell-config/neovim.nix
    ./shell-config/packages.nix
    ./shell-config/tmux.nix
  ];

  home.stateVersion = "24.05";

  # No home-manager module for aerospace exists, so just drop the raw config
  # in place. Put your aerospace.toml content in ./aerospace.toml.
  xdg.configFile."aerospace/aerospace.toml" = lib.mkIf isDarwin {
    source = ./aerospace.toml;
  };
  # Run by after-startup-command in aerospace.toml.
  xdg.configFile."aerospace/startup.sh" = lib.mkIf isDarwin {
    source = ./aerospace-startup.sh;
    executable = true;
  };

  # The launchd agent is services.sketchybar in darwin.nix; it reads ~/.config/sketchybar.
  xdg.configFile."sketchybar" = lib.mkIf isDarwin {
    source = ./sketchybar;
    recursive = true;
  };

  # Claude Code rewrites its own settings.json (/model, /config), so it can't be a
  # read-only store symlink. Merge ours over it instead: these keys win, the rest survive.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    f="$HOME/.claude/settings.json"
    tmp=$(mktemp)
    { cat "$f" 2>/dev/null || echo '{}'; } \
      | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' - ${./claude-settings.json} > "$tmp"
    run mkdir -p "$HOME/.claude"
    run mv "$tmp" "$f"
  '';

  # Prompt, on every machine (programs.starship is enabled in shell-config/bash.nix).
  xdg.configFile."starship.toml".source = ./starship.toml;

  # Ghostty reads ~/Library/Application Support/... on macOS (it overrides ~/.config),
  # and ~/.config/ghostty/config on Linux.
  # force: the old config there was a symlink into ~/.config/dotfiles, which
  # backupFileExtension doesn't handle (it only backs up regular files).
  home.file.${
    if isDarwin then
      "Library/Application Support/com.mitchellh.ghostty/config"
    else
      ".config/ghostty/config"
  }
  = {
    source = ./ghostty.config;
    force = true;
  };

  # force: was a symlink into ~/.config/dotfiles (see ghostty above).
  home.file.".ideavimrc" = {
    source = ./ideavimrc;
    force = true;
  };

  # Obsidian vault, cloned like nvim-config (shell-config/neovim.nix). Private repo:
  # on a fresh Mac this fails until `gh auth login`, then rerun the switch.
  home.activation.cloneObsidianVault = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "$HOME/Obsidian/bible" ]; then
        run ${pkgs.git}/bin/git clone https://github.com/NMJlam/obsidian.git "$HOME/Obsidian/bible" \
          || warnEcho "obsidian vault clone failed; run gh auth login, then rerun the switch"
      fi
    ''
  );

  xdg.configFile."neru/config.toml" = lib.mkIf isDarwin {
    source = ./neru.toml;
  };
}
