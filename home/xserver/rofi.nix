{ pkgs, ... }:
let
  rofiLauncherThemes = pkgs.stdenv.mkDerivation {
    name = "base16-rofi";
    src = pkgs.fetchFromGitHub {
      owner = "jordiorlando";
      repo = "base16-rofi";
      rev = "fbe876f7f75c25f27b6bc5b0572414827ee106b5";
      sha256 = "14868sfkxlcw1dz7msvvmsr95mzvv6av37wamssc5jaqjdpym8df";
    };
    buildCommand = ''
      mkdir -p $out/themes
      cp $src/themes/*.rasi $out/themes/
    '';
  };
  theme = "${rofiLauncherThemes}/themes/base16-material-darker.rasi";
in
{
  programs.rofi = {
    inherit theme;
    enable = true;
    font = "Dejavu Sans Mono 18";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      ssh-command = "{terminal} -- {terminal} +kitten ssh {host} [-p {port}]";
      show-icons = true;
      modi = "window,drun,ssh,combi";
      combi-modi = "window,drun,ssh";
      disable-history = false;
      sort = true;
      sorting-method = "fzf";
    };
  };
}
