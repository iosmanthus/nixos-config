{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../base/vscode
  ];

  home.file = {
    vscodeArgv = {
      text = ''
        {
            "enable-crash-reporter": true,
            // DO NOT EDIT THIS VALUE
            "crash-reporter-id": "6c9e4e70-6fde-4668-88c9-51329d63a7e9",
            "password-store": "basic"
        }
      '';
      target =
        ".vscode"
        + (lib.optionalString (config.programs.vscode.package == pkgs.vscode-insiders) "-insiders")
        + "/argv.json";
    };
  };

  programs.vscode = {
    package = pkgs.vscode-insiders;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "ms-vscode-remote";
        name = "remote-ssh";
        version = "0.116.2024112515";
        sha256 = "080rzj3n6bf49cfkhx7rnns45jd4gsvs8yzapnncmp2svwfhkafw";
      }
    ];
    userSettings = {
      "vim.autoSwitchInputMethod.obtainIMCmd" = "${pkgs.fcitx5}/bin/fcitx5-remote";
      "vim.autoSwitchInputMethod.switchIMCmd" = "${pkgs.fcitx5}/bin/fcitx5-remote -t {im}";
    };
  };
}
