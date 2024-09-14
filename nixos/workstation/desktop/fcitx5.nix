{ pkgs
, ...
}: {
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-adwaita-dark
          (fcitx5-rime.override {
            rimeDataPkgs = pkgs.rime-data-cantonia;
          })
        ];

        settings = {
          globalOptions = {
            "Hotkey" = {
              "ActivateKeys" = "";
              "DeactivateKeys" = "";
              "EnumerateBackwardKeys" = "";
              "EnumerateForwardKeys" = "";
              "EnumerateGroupBackwardKeys" = "";
              "EnumerateGroupForwardKeys" = "";
              "NextPage" = "";
              "PrevPage" = "";

              "EnumerateSkipFirst" = "False";
              "EnumerateWithTriggerKeys" = "True";
            };
            "Hotkey/TriggerKeys" = {
              "0" = "Shift+space";
            };
            "Hotkey/AltTriggerKeys" = {
              "0" = "Shift_L";
            };
          };

          addons = {
            # Disable the default clipboard manager
            clipboard.globalSection = {
              "TriggerKey" = "";
            };
            classicui.globalSection = {
              "Vertical Candidate List" = "True";
              "PerScreenDPI" = "True";
              "WheelForPaging" = "True";
              "Font" = "monospace 14";
              "MenuFont" = "Microsoft YaHei 14";
              "TrayFont" = "Sans Bold 10";
              "TrayOutlineColor" = "#000000";
              "TrayTextColor" = "#ffffff";
              "PreferTextIcon" = "False";
              "ShowLayoutNameInIcon" = "True";
              "UseInputMethodLangaugeToDisplayText" = "True";
              "Theme" = "adwaita-dark";
            };
          };
        };
      };
    };
  };
}
