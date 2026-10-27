# Claude Code: latest build from the claude-code flake input, plus ./settings.json.
{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  # Prebuilt by claude-code.cachix.org (modules/nix.nix).
  home.packages = [ inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code ];

  # Claude Code rewrites its own settings.json (/model, /config), so it can't be a
  # read-only store symlink. Merge ours over it instead: these keys win, the rest survive.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    f="$HOME/.claude/settings.json"
    tmp=$(mktemp)
    { cat "$f" 2>/dev/null || echo '{}'; } \
      | ${pkgs.jq}/bin/jq -s '.[0] * .[1]' - ${./settings.json} > "$tmp"
    run mkdir -p "$HOME/.claude"
    run mv "$tmp" "$f"
  '';
}
