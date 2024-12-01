{ pkgs, ... }:
let
  nextAppWin = pkgs.writers.writePython3 "nextAppWin" {
    libraries = [ ];
    flakeIgnore = [ "E501" ];
  } (builtins.readFile ./next_app_win.py);
  searchWin = pkgs.writers.writePython3 "searchWin" {
    libraries = [ ];
    flakeIgnore = [ "E501" ];
  } (builtins.readFile ./search_win.py);
in
{
  services.aerospace = {
    enable = true;
    settings = {
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      default-root-container-layout = "accordion";
      exec = {
        inherit-env-vars = true;
      };
      on-window-detected = [
        # Termainal
        {
          "if".app-id = "net.kovidgoyal.kitty";
          run = [ "move-node-to-workspace 1" ];
        }
        # Browsers
        {
          "if".app-id = "org.mozilla.firefox";
          run = [ "move-node-to-workspace 1" ];
        }
        # Mail
        {
          "if".app-id = "com.apple.mail";
          run = [ "move-node-to-workspace 3" ];
        }
        # Music
        {
          "if".app-id = "com.apple.Music";
          run = [ "move-node-to-workspace 4" ];
        }
        # IMs
        {
          "if".app-id = "ru.keepcoder.Telegram";
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if".app-id = "com.hnc.Discord";
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if".app-id = "com.tencent.xinWeChat";
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if".app-id = "com.electron.lark";
          run = [ "move-node-to-workspace 2" ];
        }
        # Notes
        {
          "if".app-id = "com.electron.logseq";
          run = [ "move-node-to-workspace 5" ];
        }
      ];
      mode.main.binding = {
        alt-s = "layout v_accordion"; # "layout stacking" in i3
        alt-w = "layout h_accordion"; # "layout tabbed" in i3
        alt-e = "layout tiles horizontal vertical"; # "layout toggle split" in i3
        alt-shift-space = "layout floating tiling"; # 'floating toggle' in i3

        alt-v = "split vertical";
        alt-shift-v = "split horizontal";

        alt-f = "fullscreen";
        alt-shift-f = "macos-native-fullscreen";
        alt-q = "close --quit-if-last-window";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-leftSquareBracket = "exec-and-forget ${nextAppWin} prev";
        alt-rightSquareBracket = "exec-and-forget ${nextAppWin} next";
        alt-p = "exec-and-forget ${searchWin}";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";

        alt-tab = "workspace-back-and-forth";

        alt-b = "exec-and-forget open /Applications/Firefox.app";
        alt-c = "exec-and-forget open ${pkgs.vscode}/Applications/Visual\\ Studio\\ Code.app";
        alt-enter = "exec-and-forget open ${pkgs.kitty}/Applications/kitty.app";
        alt-m = "exec-and-forget open /System/Applications/Music.app";
      };
    };
  };
}
