# Neru keyboard-driven navigation: the Homebrew cask plus its config.
{ ... }:

{
  homebrew.taps = [
    {
      name = "y3owk1n/tap";
      trusted = true;
    }
  ];
  homebrew.casks = [ "y3owk1n/tap/neru" ];

  home-manager.users.nlam.xdg.configFile."neru/config.toml".source = ./config.toml;
}
