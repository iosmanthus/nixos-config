{ config
, self
, pkgs
, ...
}: {
  programs.firefox = {
    enable = true;
    package = self.inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin.unwrapped;
    profiles.${config.admin.name} = {
      settings = {
        "browser.sessionstore.resume_from_crash" = true;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "extensions.pocket.enabled" = false;
        "network.http.http3.enable" = false;
        "network.predictor.enable-hover-on-ssl" = true;
        "network.predictor.enable-prefetch" = true;
        "network.predictor.preconnect-min-confidence" = 20;
        "network.predictor.prefetch-force-valid-for" = 3600;
        "network.predictor.prefetch-min-confidence" = 30;
        "network.predictor.prefetch-rolling-load-count" = 120;
        "network.predictor.preresolve-min-confidence" = 10;
        "network.trr.mode" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "widget.content.gtk-theme-override" = config.gtk.globalTheme.name;
        "xpinstall.signatures.required" = false;
      };
      userChrome = builtins.readFile ./userChrome.css;
    };
  };
}
