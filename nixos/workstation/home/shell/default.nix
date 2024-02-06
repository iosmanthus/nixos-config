{ config
, pkgs
, lib
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
    history = {
      share = true;
      extended = true;
    };
    autocd = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "fd"
        "git-auto-fetch"
        "git"
        "golang"
        "kubectl"
        "systemd"
      ];
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "sha256-4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
          sha256 = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];

    initExtra = ''
      # config of zsh-users/zsh-syntax-highlighting
      typeset -A ZSH_HIGHLIGHT_STYLES

      ZSH_HIGHLIGHT_STYLES[comment]='fg=magenta,bold'
      if [[ $options[zle] = on ]]; then
        zvm_after_init_commands+=(eval "$(${config.programs.atuin.package}/bin/atuin init zsh ${lib.escapeShellArgs config.programs.atuin.flags})")
      fi
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };
}
