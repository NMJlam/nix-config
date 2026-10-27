# JetBrains IDEs (installed through JetBrains Toolbox) plus IdeaVim, their
# Vim emulation, configured by ./ideavimrc.
{ username, ... }:

{
  homebrew.casks = [ "jetbrains-toolbox" ];

  # force: was a symlink into ~/.config/dotfiles (see ../ghostty).
  home-manager.users.${username}.home.file.".ideavimrc" = {
    source = ./ideavimrc;
    force = true;
  };
}
