# Values shared by the homelab's network and app modules. Change them here only.
{ lib, ... }:

{
  options.homelab.domain = lib.mkOption { type = lib.types.str; };

  config.homelab.domain = "mjlam.dev";
}
