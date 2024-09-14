{ ... }:
let
  sopsFile = ./secrets.yaml;
in
{
  sops = {
    secrets = {
      "cloudflare/api-token" = {
        inherit sopsFile;
      };
    };
  };
}
