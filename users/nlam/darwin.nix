{ pkgs, ... }:

{
  users.users.nlam.home = "/Users/nlam";

  # Modern bash as a login shell (macOS ships 3.2). Switch once with:
  #   chsh -s /run/current-system/sw/bin/bash
  environment.shells = [ pkgs.bashInteractive ];
  environment.systemPackages = [ pkgs.bashInteractive ];

  # Config is users/nlam/sketchybar (linked by home-manager).
  services.sketchybar = {
    enable = true;
    extraPackages = [ pkgs.sketchybar-app-font ]; # icon_map.sh for plugins/aerospace.sh
  };
  # Plugin scripts inherit this PATH: aerospace/brew live in Homebrew, gh/jq in home-manager.
  launchd.user.agents.sketchybar.path = [
    "/opt/homebrew/bin"
    "/etc/profiles/per-user/nlam/bin"
  ];
  fonts.packages = [ pkgs.sketchybar-app-font ];

  system.defaults.NSGlobalDomain = {
    _HIHideMenuBar = true; # sketchybar replaces it
    AppleInterfaceStyle = "Dark";
    ApplePressAndHoldEnabled = false; # repeat on hold, no accent popup
    KeyRepeat = 2; # fastest on the Settings slider
    InitialKeyRepeat = 15; # shortest delay on the slider
  };

  system.defaults.dock = {
    autohide = true;
    tilesize = 79;
  };

  # Quit apps don't restore their old windows (else Ghostty comes back with 4).
  system.defaults.CustomUserPreferences.NSGlobalDomain.NSQuitAlwaysKeepsWindows = false;

  # Untick "Reopen windows when logging back in". It lives in a ByHost plist,
  # which system.defaults can't target.
  system.activationScripts.postActivation.text = ''
    launchctl asuser "$(id -u -- nlam)" sudo --user=nlam -- \
      defaults -currentHost write com.apple.loginwindow TALLogoutSavesState -bool false
  '';
}
