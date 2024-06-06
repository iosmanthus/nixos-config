{ ... }:
let
  sopsFile = ./secrets.yaml;
in
{
  sops = {
    secrets = {
      "grafana/promtail-basic-auth" = { inherit sopsFile; };
      "grafana/prometheus-basic-auth" = { inherit sopsFile; };
    };
  };
}
