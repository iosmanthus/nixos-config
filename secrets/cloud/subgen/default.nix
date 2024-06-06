{ ... }:
let
  sopsFile = ./secrets.json;
  format = "json";
in
{
  sops.secrets = {
    "subgen/subscription-url" = { inherit sopsFile format; };
    "subgen/users" = { inherit sopsFile format; };
  };
}
