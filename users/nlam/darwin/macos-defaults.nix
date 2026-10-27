# macOS System Settings: keyboard, dock, window restore.
{ username, ... }:

{
  system.defaults.NSGlobalDomain = {
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
    launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
      defaults -currentHost write com.apple.loginwindow TALLogoutSavesState -bool false
  '';
}
