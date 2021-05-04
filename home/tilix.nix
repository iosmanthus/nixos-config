{ lib, pkgs, ... }: {
  home.packages = with pkgs;[
    tilix
  ];
  dconf.settings = {
    "com/gexperts/Tilix" = {
      theme-variant = "dark";
      accelerators-enabled = true;
      new-instance-mode = "focus-window";
      prompt-on-delete-profile = true;
      quake-specific-monitor = 0;
    };

    "com/gexperts/Tilix/keybindings" = {
      session-open = "disabled";
      terminal-file-browser = "<Primary><Shift>o";
      session-switch-to-terminal-down = "<Alt>j";
      session-switch-to-terminal-left = "<Alt>h";
      session-switch-to-terminal-right = "<Alt>l";
      session-switch-to-terminal-up = "<Alt>k";
    };

    "com/gexperts/Tilix/profiles" = {
      default = "2b7c4080-0ddd-46c5-8f23-563fd3ba789d";
      list = [ "2b7c4080-0ddd-46c5-8f23-563fd3ba789d" ];
    };

    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      background-color = "#212121";
      background-transparency-percent = 0;
      badge-color-set = false;
      bold-color-set = false;
      bold-is-bright = true;
      cursor-colors-set = false;
      default-size-columns = 120;
      default-size-rows = 40;
      font = "Monospace 13";
      foreground-color = "#B2CCD6";
      highlight-colors-set = false;
      palette = [ "#212121" "#F07178" "#C3E88D" "#FFCB6B" "#82AAFF" "#C792EA" "#89DDFF" "#EEFFFF" "#4A4A4A" "#F07178" "#C3E88D" "#FFCB6B" "#82AAFF" "#C792EA" "#89DDFF" "#FFFFFF" ];
      use-system-font = false;
      use-theme-colors = false;
      visible-name = "Default";
    };
  };
}
