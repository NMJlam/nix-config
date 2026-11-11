# omp's MCP servers (./servers.json). Claude Code gets camoufox from its plugin instead (../claude).
{ lib, pkgs, ... }:

{
  # omp (Homebrew, Mac) owns the rest of its mcp.json.
  home.activation.ompMcp = lib.mkIf pkgs.stdenv.isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      f="$HOME/.omp/agent/mcp.json"
      tmp=$(mktemp)
      { cat "$f" 2>/dev/null || echo '{}'; } \
        | ${pkgs.jq}/bin/jq --slurpfile s ${./servers.json} '.mcpServers = $s[0]' > "$tmp"
      run mkdir -p "$HOME/.omp/agent"
      run mv "$tmp" "$f"
    ''
  );
}
