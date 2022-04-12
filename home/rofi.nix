{ pkgs, ... }:
let
  mkbase16Rofitheme = name: "${pkgs.base16-rofi}/themes/${name}.rasi";
in
{
  programs.rofi = {
    theme = mkbase16Rofitheme "base16-material-darker";
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
