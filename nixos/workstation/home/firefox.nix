{ config
, ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${config.admin.name} = {
      settings = {
        "browser.sessionstore.resume_from_crash" = false;
        "network.dns.disablePrefetchFromHTTPS" = false;
        "network.predictor.enable-hover-on-ssl" = true;
        "network.predictor.enable-prefetch" = true;
        "network.predictor.preconnect-min-confidence" = 20;
        "network.predictor.prefetch-force-valid-for" = 3600;
        "network.predictor.prefetch-min-confidence" = 30;
        "network.predictor.prefetch-rolling-load-count" = 120;
        "network.predictor.preresolve-min-confidence" = 10;
        "network.prefetch-next" = true;
        "network.ssl_tokens_cache_capacity" = 32768;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.content.gtk-theme-override" = config.gtk.globalTheme.name;
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
          font-size: 13pt !important;
        }
      '';
    };
  };
}
