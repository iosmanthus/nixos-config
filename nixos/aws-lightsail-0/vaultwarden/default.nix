{ config
, ...
}: {
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    config = {
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = false;
      INVITATIONS_ALLOWED = false;
      WEB_VAULT_ENABLED = true;
      WEBSOCKET_ENABLED = true;
      PUSH_ENABLED = true;
    };
    environmentFile = config.sops.secrets."vaultwarden/env".path;
  };
}
