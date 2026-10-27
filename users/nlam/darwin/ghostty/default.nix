# Ghostty terminal: the Homebrew cask plus its config.
# The homelab only needs ghostty's terminfo (machines/homelab) for SSH sessions.
{ ... }:

{
  homebrew.casks = [ "ghostty" ];

  # Ghostty reads ~/Library/Application Support/... on macOS (it overrides ~/.config).
  # force: the old config there was a symlink into ~/.config/dotfiles, which
  # backupFileExtension doesn't handle (it only backs up regular files).
  home-manager.users.nlam.home.file."Library/Application Support/com.mitchellh.ghostty/config" = {
    source = ./config;
    force = true;
  };
}
