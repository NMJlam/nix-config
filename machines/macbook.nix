# MacBook Pro (Mac16,8, Apple M4 Pro)
{ ... }:

{
  # vim, nixd and nixfmt now come from users/nlam/shell-config (shared with the homelab).
  nix.settings.experimental-features = "nix-command flakes";

  # Install Homebrew itself under /opt/homebrew. autoMigrate takes over an
  # existing install from the official script instead of failing on it.
  nix-homebrew = {
    enable = true;
    autoMigrate = true;
  };

  # Homebrew is only for what nixpkgs can't cover. "zap" uninstalls anything not listed here.
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    # Puts /opt/homebrew/bin on PATH (brew shellenv) so bun below is found.
    enableBashIntegration = true;
    # Homebrew 6 refuses untrusted third-party taps, which would abort activation.
    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
          "can1357/tap" # omp
          "felixkratz/formulae" # borders
          "nikitabobko/tap" # aerospace
          "oven-sh/bun" # bun
          "y3owk1n/tap" # neru
        ];
    brews = [
      "can1357/tap/omp" # not in nixpkgs; a newer copy also lives in ~/.bun/bin
      "felixkratz/formulae/borders"
      "oven-sh/bun/bun" # tracks upstream; nixpkgs stable is too old for omp
      "gcc" # g++-16 is clangd's --query-driver in nvim-config (cpp_lsp.lua)
    ];
    casks = [
      "anki"
      "arc"
      "claude"
      "discord"
      "font-meslo-lg-nerd-font"
      "font-symbols-only-nerd-font"
      "ghostty"
      "jetbrains-toolbox"
      "nikitabobko/tap/aerospace"
      "obsidian"
      "orbstack"
      "postman"
      "secretive"
      "slack"
      "spotify"
      "tailscale-app"
      "y3owk1n/tap/neru"
      "zoom"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
}
