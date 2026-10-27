# JetBrains IDEs (installed through JetBrains Toolbox) plus IdeaVim, their
# Vim emulation, configured by ./ideavimrc.
{ ... }:

{
  homebrew.casks = [ "jetbrains-toolbox" ];

  # force: was a symlink into ~/.config/dotfiles (see ../ghostty).
  home-manager.users.nlam.home.file.".ideavimrc" = {
    source = ./ideavimrc;
    force = true;
  };
}
