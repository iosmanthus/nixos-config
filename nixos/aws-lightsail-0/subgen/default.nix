{ config
, ...
}: {
  iosmanthus.subgen = {
    enable = true;
    configFile = config.sops.templates."config.jsonnet".path;
    exprPath = ./.;
    restartTriggers = [ config.sops.templates."config.jsonnet".content ];
  };
}
