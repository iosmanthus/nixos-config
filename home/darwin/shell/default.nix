{ ... }:
{
  imports = [
    ../../base/shell
  ];

  programs.zsh = {
    shellAliases = {
      switch = "darwin-rebuild switch --flake ~/nixos-config";
    };
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
