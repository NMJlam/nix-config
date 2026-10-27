# Vi mode, 100ms escape timeout, Ghostty's Ctrl+[ (CSI-u) -> normal mode.
{ ... }:

{
  programs.readline = {
    enable = true;
    variables = {
      editing-mode = "vi";
      keyseq-timeout = 100;
    };
    extraConfig = ''
      # Cursor shape per vi mode: block in normal mode, bar in insert mode.
      # \1 and \2 mark the escape codes as invisible so the prompt width stays right.
      set show-mode-in-prompt on
      set vi-cmd-mode-string "\1\e[2 q\2"
      set vi-ins-mode-string "\1\e[6 q\2"

      set keymap vi-insert
      "\e[91;5u": vi-movement-mode
      # vi-insert has no Ctrl-L by default (only vi-command does).
      "\C-l": clear-screen
    '';
  };
}
