When I ask to be taught, tutored, quizzed, or drilled on a topic, use the `socratic-tutor` skill (~/.claude/skills/socratic-tutor, managed in ~/Repositories/flake).

For web search use WebSearch / WebFetch (omp: `web_search`). If a fetch is blocked, empty, or only a JS shell, retry it with Camoufox.

# Make sure Camoufox is up before using it
Call the `camoufox_status` tool. If it reports `"browserAvailable": false`, download the browser binary, then check it launches:

    npx --yes --package camoufox-mcp-server@latest camoufox-mcp-fetch
    npx --yes --package camoufox-mcp-server@latest camoufox-mcp-doctor

Never use `camoufox-js fetch`: it can install a build that bypasses WebSocket interception.
