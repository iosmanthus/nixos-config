{ pkgs, ... }: {
  programs.zsh = {
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.1.0";
          sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "ebef4e55691f62e630318d56468e5798367aa81c";
          sha256 = "sha256-i2AT28UvxbYYEUNDR7tbDA2MJyKWYVmJqROWYkBaNWI=";
        };
      }
    ];
  };
}
