# Claude Code: latest build from the claude-code flake input, plus ./settings.json and ./CLAUDE.md.
# Plugins are declared in the settings files; Claude fetches them.
{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  # Camoufox (Firefox build) is Mac-only: its downloaded binary doesn't run on NixOS.
  settingsFiles = [ ./settings.json ] ++ lib.optional pkgs.stdenv.isDarwin ./settings-darwin.json;
in
{
  # Prebuilt by claude-code.cachix.org (modules/nix.nix).
  home.packages = [ inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code ];

  # omp reads this file too.
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;

  # Claude Code rewrites its own settings.json (/model, /config), so it can't be a
  # read-only store symlink. Merge ours over it instead: these keys win, the rest survive.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    f="$HOME/.claude/settings.json"
    tmp=$(mktemp)
    { cat "$f" 2>/dev/null || echo '{}'; } \
      | ${pkgs.jq}/bin/jq -s 'reduce .[] as $x ({}; . * $x)' - ${lib.escapeShellArgs settingsFiles} > "$tmp"
    run mkdir -p "$HOME/.claude"
    run mv "$tmp" "$f"
  '';
}
