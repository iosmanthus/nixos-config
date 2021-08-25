{ config
, pkgs
, ...
}: {
  imports = [
    ./starship.nix
    ./alias.nix
  ];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableVteIntegration = true;
    history = rec {
      share = true;
      save = 1048576;
      size = save;
    };
    autocd = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "git"
        "vi-mode"
        "cargo"
        "golang"
      ];
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.1.0";
          sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "ebef4e55691f62e630318d56468e5798367aa81c";
          sha256 = "0qimb90655hkm64mjqcn48kqq38cbfxlfhs324cbdi9gqpdi6q4b";
        };
      }
    ];

    initExtra = ''
      # config of zsh-users/zsh-syntax-highlighting
      typeset -A ZSH_HIGHLIGHT_STYLES

      ZSH_HIGHLIGHT_STYLES[comment]='fg=magenta,bold'
    '';
  };
}
