{
  pkgs,
  hostName,
  ...
}:
{
  system = {
    stateVersion = 5;
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    activationScripts.postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
        ApplePressAndHoldEnabled = false;
        AppleInterfaceStyle = "Dark";

        "com.apple.swipescrolldirection" = false;
      };
      WindowManager = {
        GloballyEnabled = false;
      };
      CustomUserPreferences = {
        "com.apple.HIToolbox" = {
          AppleDictationAutoEnable = false;
        };
        "com.apple.assistant.support" = {
          "Dictation Enabled" = false;
        };
        "com.apple.dock" = {
          expose-group-apps = true;
        };
      };
      smb = {
        NetBIOSName = hostName;
      };
      dock = {
        autohide = true;
        autohide-time-modifier = 0.2;
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/Music.app"

          "/Applications/Firefox.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          "/Applications/Telegram.app"
          "/Applications/Logseq.app"
          "/Applications/SFM.app"
        ];
      };
    };
  };

}
