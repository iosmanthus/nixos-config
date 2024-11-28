{
  config,
  pkgs,
  ...
}:
let
  hostName = "iosmanthus-macmini";
in
{
  imports = [
    ./homebrew
  ];

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.nix_2_22;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-going = true
      download-attempts = 2
      connect-timeout = 5
    '';
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };
  };

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
        ApplePressAndHoldEnabled = false;
        AppleInterfaceStyle = "Dark";

        "com.apple.swipescrolldirection" = false;
      };
      WindowManager = {
        GloballyEnabled = true;
        AppWindowGroupingBehavior = false;
      };
      CustomUserPreferences = {
        "com.apple.HIToolbox" = {
          AppleDictationAutoEnable = false;
        };
        "com.apple.assistant.support" = {
          "Dictation Enabled" = false;
        };
      };
      smb = {
        NetBIOSName = hostName;
      };
      dock = {
        autohide = true;
        persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/System/Applications/Music.app"

          "/Applications/Firefox.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          "/Applications/Telegram.app"
          "/Applications/SFM.app"
        ];
      };
    };
  };

  programs.zsh.enable = true;
  networking = rec {
    inherit hostName;
    computerName = hostName;
  };

  users.users.${config.admin.name} = {
    inherit (config.admin) shell home;
    description = config.admin.name;
    openssh.authorizedKeys.keys = [ config.admin.sshPubKey ]; };

  nix.settings.trusted-users = [ config.admin.name ];
}
