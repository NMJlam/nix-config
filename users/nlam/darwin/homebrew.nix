# Homebrew, only for what nixpkgs can't cover. Apps with their own module
# (aerospace, ghostty, jetbrains, neru, sketchybar) list their cask there instead.
{ ... }:

{
  # Install Homebrew itself under /opt/homebrew. autoMigrate takes over an
  # existing install from the official script instead of failing on it.
  nix-homebrew = {
    enable = true;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    # "zap" uninstalls anything not listed in some module.
    onActivation.cleanup = "zap";
    # Puts /opt/homebrew/bin on PATH (brew shellenv) so bun below is found.
    enableBashIntegration = true;
    # Homebrew 6 refuses untrusted third-party taps, which would abort activation.
    # Modules that add a tap must set trusted = true too.
    taps =
      map
        (name: {
          inherit name;
          trusted = true;
        })
        [
          "can1357/tap" # omp
          "felixkratz/formulae" # borders
          "oven-sh/bun" # bun
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
      "obsidian"
      "font-meslo-lg-nerd-font"
      "font-symbols-only-nerd-font"
      "orbstack"
      "postman"
      "secretive"
      "slack"
      "spotify"
      "tailscale-app"
      "zoom"
    ];
  };
}
