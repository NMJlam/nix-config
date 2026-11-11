# Skills linked into ~/.claude/skills straight from flake inputs tracking upstream (flake.nix).
{ lib, inputs, ... }:

let
  skills = {
    socratic-tutor = "${inputs.janestreet-skills}/socratic-tutor";
    # pstack calls these but ships them in cursor-team-kit, which isn't in the Claude marketplace.
    deslop = "${inputs.cursor-plugins}/cursor-team-kit/skills/deslop";
    control-cli = "${inputs.cursor-plugins}/cursor-team-kit/skills/control-cli";
    control-ui = "${inputs.cursor-plugins}/cursor-team-kit/skills/control-ui";
    # grill-me only runs /grilling.
    grill-me = "${inputs.mattpocock-skills}/skills/productivity/grill-me";
    grilling = "${inputs.mattpocock-skills}/skills/productivity/grilling";
  };
in
{
  home.file = lib.mapAttrs' (
    name: source: lib.nameValuePair ".claude/skills/${name}" { inherit source; }
  ) skills;
}
