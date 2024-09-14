{ config, ... }:
{
  sops.templates."atuin.env".content = ''
    ATUIN_HOST="127.0.0.1"
    ATUIN_MAX_HISTORY_LENGTH=131072
    ATUIN_OPEN_REGISTRATION=false
    ATUIN_PAGE_SIZE=2048
    ATUIN_PORT=8888
    RUST_LOG="info,atuin_server=debug"

    ATUIN_DB_URI="${config.sops.placeholder."atuin/db-uri"}"
  '';

  systemd.services.atuin.restartTriggers = [ config.sops.templates."atuin.env".content ];

  services.self-hosted.atuin = {
    enable = true;
    environmentFile = config.sops.templates."atuin.env".path;
  };
}
