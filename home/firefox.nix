{ pkgs
, config
, lib
, ...
}: {
  programs.firefox = {
    enable = true;
    # TODO: port every extensions to nix
    extensions = builtins.map pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon [{
      pname = "material-darker-vs-code";
      version = "1.1";
      addonId = "{9cf33cf9-0bab-48f9-98be-b0ded0024a47}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3470572/material_darker_vs_code-1.1.xpi";
      sha256 = "0g28f2z7b0yycgm8yrfcq0x11albsdjp733vhr7snzalhv1w3bvw";
      meta = with lib; {
        description = "Firefox Theme based on the Material Theme (Darker) by Mattia Astorino";
        license = licenses.cc-by-30;
        platforms = platforms.all;
      };
    }];
    profiles.${config.machine.userName} = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.sessionstore.resume_from_crash" = false;
        "widget.content.gtk-theme-override" = "Graphite-Dark";
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
