# SketchyBar status bar (replaces the macOS menu bar). The bar itself is ./config.
{
  lib,
  pkgs,
  username,
  ...
}:

{
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.sketchybar-app-font ]; # icon_map.sh for plugins/aerospace.sh
  };
  # Plugin scripts inherit this PATH: aerospace in Homebrew, jq in home-manager,
  # tailscale CLI installed by the Tailscale app.
  # mkBefore: ahead of the service's default PATH.
  launchd.user.agents.sketchybar.path = lib.mkBefore [
    "/opt/homebrew/bin"
    "/etc/profiles/per-user/${username}/bin"
    "/usr/local/bin"
  ];

  fonts.packages = [ pkgs.sketchybar-app-font ];
  homebrew.casks = [ "font-sf-pro" ]; # SF Symbols glyphs used by the bar

  system.defaults.NSGlobalDomain._HIHideMenuBar = true;

  # The launchd agent reads ~/.config/sketchybar.
  home-manager.users.${username}.xdg.configFile."sketchybar" = {
    source = ./config;
    recursive = true;
  };
}
