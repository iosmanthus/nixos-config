{ config
, pkgs
, ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${config.machine.userName} = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"])
          #TabsToolbar
          > .toolbar-items {
          opacity: 0;
          pointer-events: none;
        }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
          visibility: collapse !important;
        }

        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
          display: none;
        }

        #urlbar {
          font-size: 15pt !important;
        }
      '';
    };
  };
}
