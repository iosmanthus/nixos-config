{ pkgs, ... }: {
  home.packages = [ pkgs.xsel ];
  programs.tmux = {
    enable = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    clock24 = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.mkTmuxPlugin {
          pluginName = "base16";
          version = "unstable-2021-04-03";
          src = fetchFromGitHub {
            owner = "mattdavis90";
            repo = "base16-tmux";
            rev = "810ba8f86f028b467353e22837f8c89eb46fc287";
            sha256 = "sha256-CHDSb3uA1g3nPCED8/jMgP4xBMkk9LtGNEuJw4LJr+Q=";
          };
          rtpFilePath = "tmuxcolors.tmux";
        };
        extraConfig = ''
          set -g @colors-base16 'gruvbox-dark-medium'
        '';
      }
      {
        plugin = tmuxPlugins.mkTmuxPlugin {
          pluginName = "yank";
          version = "unstable-2020-10-02";
          src = fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tmux-yank";
            rev = "1b1a436e19f095ae8f825243dbe29800a8acd25c";
            sha256 = "sha256-hRvkBf+YrWycecnDixAsD4CAHg3KsioomfJ/nLl5Zgs=";
          };
        };
      }
    ];
    extraConfig = ''
      set -g mouse
      set -g default-terminal "tmux-256color"
    '';
  };
}
