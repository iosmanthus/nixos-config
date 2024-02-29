{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./theme.rasi;
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      show-icons = true;
      modi = "window,drun,combi";
      combi-modi = "window,drun,calc";
      disable-history = false;
      display-drun = "   Apps ";
      display-window = " 﩯  Window";
      sidebar-mode = true;
      sort = true;
      sorting-method = "fzf";
    };
  };
}
