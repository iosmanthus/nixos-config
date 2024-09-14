{ ... }:
let
  sopsFile = ./secrets.yaml;
in
{
  sops = {
    secrets = {
      "aws-lightsail-0/external-address-v4" = {
        inherit sopsFile;
      };
      "gcp-instance-0/external-address-v4" = {
        inherit sopsFile;
      };
      "gcp-instance-2/external-address-v4" = {
        inherit sopsFile;
      };
    };
  };
}
