# nlam on macOS. Each Mac-only tool is one module here; it owns its Homebrew
# install, system settings and home-manager files, so deleting it removes the tool.
{ username, ... }:

{
  imports = [
    ./aerospace
    ./ghostty
    ./homebrew.nix
    ./jetbrains
    ./login-shell.nix
    ./macos-defaults.nix
    ./neru
    ./sketchybar
  ];

  users.users.${username}.home = "/Users/${username}";
}
