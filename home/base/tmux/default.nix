{ pkgs, config, ... }:
{
  home.packages = [ pkgs.xsel ];
  programs.tmux = {
    enable = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    clock24 = true;
    sensibleOnTop = true;
    plugins = [
      {
        plugin = pkgs.minimal-tmux-status;
        extraConfig = ''
          set -g @minimal-tmux-justify "left"
          set -g @minimal-tmux-bg "${config.scheme.withHashtag.base0D}"
          set -g @minimal-tmux-indicator-str " 😊 "
        '';
      }
      { plugin = pkgs.tmux-yank; }
    ];
    extraConfig = ''
      set -g mouse
      set -g default-terminal "tmux-256color"
      set -g escape-time 0
      bind  c  new-window      -c "#{pane_current_path}"
      bind  %  split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
    '';
  };
}
