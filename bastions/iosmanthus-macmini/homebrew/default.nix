{
  config,
  lib,
  ...
}:
{
  environment.systemPath = lib.optionals config.homebrew.enable [
    config.homebrew.brewPrefix
  ];

  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    brews = [
      "choose-gui"
    ];
    casks = [
      "discord"
      "feishu"
      "firefox"
      "jetbrains-toolbox"
      "logi-options+"
      "logseq"
      "maccy"
      "sfm"
      "squirrel"
      "telegram"
      "wechat"
    ];
  };
}
