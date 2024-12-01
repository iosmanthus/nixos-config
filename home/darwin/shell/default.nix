{ ... }:
{
  imports = [
    ../../base/shell
  ];

  programs.zsh = {
    shellAliases = {
      drs = "darwin-rebuild switch --flake ~/nixos-config";
    };
    initExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };
}
