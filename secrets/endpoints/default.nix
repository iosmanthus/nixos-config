{ ... }:
let
  sopsFile = ./secrets.yaml;
in
{
  sops = {
    secrets = {
      "aws-lightsail-0/external-address-v4" = { inherit sopsFile; };
      "aws-lightsail-0/external-address-v6" = { inherit sopsFile; };
      "gcp-instance-0/external-address-v4" = { inherit sopsFile; };
      "gcp-instance-0/external-address-v6" = { inherit sopsFile; };
    };
  };
}
