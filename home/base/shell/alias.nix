{ pkgs, ... }:
let
  ignoreOutput = pkgs.writers.writePython3 "ignore_output" { libraries = [ ]; } ''
    import subprocess
    import sys

    subprocess.Popen(
      sys.argv[1:],
      stdout=subprocess.DEVNULL,
      stderr=subprocess.DEVNULL
    )
  '';
in
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

      clion = "${ignoreOutput} clion nosplash";
      goland = "${ignoreOutput} goland nosplash";
      idea-ultimate = "${ignoreOutput} idea-ultimate nosplash";
      rr = "${ignoreOutput} rust-rover nosplash";
      webstorm = "${ignoreOutput} webstorm nosplash";

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
