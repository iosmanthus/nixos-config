{ pkgs
, ...
}: {
  imports = [
    ./starship.nix
    ./alias.nix
  ];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
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
        "golang"
        "fd"
        "systemd"
        "git-auto-fetch"
      ];
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "c5ce0014677a0f69a10b676b6038ad127f40c6b1";
          sha256 = "000ksv6bb4qkdzp6fdgz8z126pwin6ywib5d6cfwqa2w27xqm9sj";
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
