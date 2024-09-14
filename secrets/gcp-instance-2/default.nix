{ ... }:
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "cloudflare/warp/private_key" = { };
      "cloudflare/warp/peer_public_key" = { };
      "cloudflare/warp/local_address_v4" = { };
      "cloudflare/warp/local_address_v6" = { };

      "grafana/promtail-basic-auth" = { };
      "grafana/prometheus-basic-auth" = { };
    };
  };
}
