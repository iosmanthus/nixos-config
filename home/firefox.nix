{ config
, ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${config.machine.userName} = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.sessionstore.resume_from_crash" = false;
        "widget.content.gtk-theme-override" = config.gtk.globalTheme.name;
        "network.prefetch-next" = true;
        "network.predictor.enable-prefetch" = true;
        "network.dns.disablePrefetchFromHTTPS" = false;
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
