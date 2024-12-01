{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bat
    eza
    bind
  ];

  programs.zsh = {
    shellAliases = {
      ls = "eza --group-directories-first";
      la = "ls -a";
      ll = "ls -l";
      l = "ls -F";

      cat = "bat --theme base16";

      vim = "nvim";
      vi = "vim";

      py = "python";
      py2 = "python2";

      dig = "dig +ttlunits";

      k = "kubectl";
      kx = "kubectx";

      code = "${pkgs.vscode-launcher}";

      n = "nix";
      nrs = "nixos-rebuild switch --use-remote-sudo";
      nix32 = "nix hash convert --to nix32";

      tf = "terraform";
    };
  };
}
