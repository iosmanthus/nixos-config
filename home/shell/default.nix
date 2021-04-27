{ config
, pkgs
, ...
}: {
  imports = [
    ./starship.nix
    ./alias.nix
    ./zsh-plugins.nix
  ];
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
  };
}
