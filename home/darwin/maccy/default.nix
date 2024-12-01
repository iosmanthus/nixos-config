{ ... }:
{
  launchd.agents.maccy = {
    enable = true;
    config = {
      ProgramArguments = [
        "open"
        "-g"
        "/Applications/Maccy.app"
      ];
      RunAtLoad = true;
    };
  };
}
