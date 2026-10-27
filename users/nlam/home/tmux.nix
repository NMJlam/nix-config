# Ported from the old ~/.tmux.conf. Plugins come from nixpkgs instead of TPM.
{ pkgs, ... }:

let
  # Mac copies via pbcopy; elsewhere set-clipboard (OSC 52) carries it back over SSH.
  copy =
    if pkgs.stdenv.isDarwin then ''copy-pipe-and-cancel "pbcopy"'' else "copy-selection-and-cancel";
in
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    baseIndex = 1;
    keyMode = "vi";
    escapeTime = 10; # home-manager defaults to 500; tmux's own default is 10
    sensibleOnTop = false;
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.dotbar;
        extraConfig = ''
          set -g @tmux-dotbar-bg default
          set -g @tmux-dotbar-window-status-format " #I:#W "
        '';
      }
    ];
    extraConfig = ''
      # Ghostty terminal support
      set -ga terminal-overrides ",xterm-ghostty:Tc"
      set -ga terminal-overrides ",xterm-ghostty:RGB"

      # Override status after plugin loads
      set -g status-left ""
      set -g status-right ""
      set-window-option -g window-status-current-style "bg=#1e1e2e,fg=#cba6f7,bold"

      set-option -g renumber-windows on

      # Vim pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind x kill-pane

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X ${copy}
      bind-key -T copy-mode-vi Enter send-keys -X ${copy}
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X ${copy}

      set -s set-clipboard on
    '';
  };
}
