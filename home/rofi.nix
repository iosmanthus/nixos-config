{ pkgs, ... }:
let
  mkbase16Rofitheme = name: "${pkgs.base16-rofi}/themes/${name}.rasi";
  patchTheme = path: patch: pkgs.writeText "theme.rasi" ''
    ${builtins.readFile path}
    ${patch}
  '';
  theme = "${patchTheme (mkbase16Rofitheme "base16-material-darker") ''
      element-icon { 
        size: 2ch; 
      }
  ''}";
in
{
  programs.rofi = {
    inherit theme;
    enable = true;
    font = "monospace 20";
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
