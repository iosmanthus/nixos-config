{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./starship.nix
    ./alias.nix
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      keymap_mode = "vim-normal";
      search_mode = "fuzzy";
      style = "compact";
      sync_address = "https://atuin.iosmanthus.com";
      sync_frequency = "10m";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
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
        "git-auto-fetch"
        "git"
        "golang"
        "kubectl"
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
}
