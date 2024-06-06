{ ... }:
let
  sopsFile = ./secrets.yaml;
in
{
  sops = {
    secrets = {
      "aws-lightsail-0/external-address-v4" = { inherit sopsFile; };
      "gcp-instance-0/external-address-v4" = { inherit sopsFile; };
      "gcp-instance-1/external-address-v4" = { inherit sopsFile; };
    };
  };
}
