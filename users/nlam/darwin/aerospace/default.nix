# AeroSpace tiling window manager: the Homebrew cask plus its config.
{ username, ... }:

{
  homebrew.taps = [
    {
      name = "nikitabobko/tap";
      trusted = true;
    }
  ];
  homebrew.casks = [ "nikitabobko/tap/aerospace" ];

  # No home-manager module for aerospace exists, so just drop the raw config in place.
  home-manager.users.${username} = {
    xdg.configFile."aerospace/aerospace.toml".source = ./aerospace.toml;
    # Run by after-startup-command in aerospace.toml.
    xdg.configFile."aerospace/startup.sh" = {
      source = ./startup.sh;
      executable = true;
    };
  };
}
