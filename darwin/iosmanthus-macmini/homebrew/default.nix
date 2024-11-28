{
  ...
}:
{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [
      "discord"
      "feishu"
      "firefox"
      "jetbrains-toolbox"
      "maccy"
      "sfm"
      "squirrel"
      "telegram"
      "wechat"
    ];
  };
}
