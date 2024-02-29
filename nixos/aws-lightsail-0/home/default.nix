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
    history = {
      share = true;
      extended = true;
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

    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "regexp"
        "root"
        "line"
      ];
      styles = {
        comment = "fg=magenta,bold";
      };
    };

    initExtra = ''
      if [[ $options[zle] = on ]]; then
        zvm_after_init_commands+=(eval "$(${config.programs.atuin.package}/bin/atuin init zsh ${lib.escapeShellArgs config.programs.atuin.flags})")
      fi
      source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
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
