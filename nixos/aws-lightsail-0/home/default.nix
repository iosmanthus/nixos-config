{ lib
, config
, pkgs
, ...
}: {
  home.stateVersion = "23.05";

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
      extended = true;
      size = save;
    };
    autocd = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "fd"
        "git"
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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      auto_sync = true;
      keymap_mode = "vim-normal";
      search_mode = "fuzzy";
      style = "compact";
      sync_address = "http://127.0.0.1:8888";
      sync_frequency = "10s";
    };
  };
}
