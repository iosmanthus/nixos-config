{ ... }:
let
  sopsFile = ./secrets.json;
  format = "json";
in
{
  sops = {
    secrets = {
      "sing-box/vless/reality/server-name" = { inherit sopsFile format; };
      "sing-box/vless/reality/public-key" = { inherit sopsFile format; };
      "sing-box/vless/reality/private-key" = { inherit sopsFile format; };
      "sing-box/vless/reality/short-id" = { inherit sopsFile format; };
      "sing-box/vless/users" = { inherit sopsFile format; };
    };
  };
}
