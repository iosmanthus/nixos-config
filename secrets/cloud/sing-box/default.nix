{ ... }:
let
  sopsFile = ./secrets.json;
  format = "json";
in
{
  sops = {
    secrets = {
      "sing-box/shadowsocks/method" = { inherit sopsFile format; };
      "sing-box/shadowsocks/password" = { inherit sopsFile format; };
      "sing-box/shadowsocks/users" = { inherit sopsFile format; };

      "sing-box/shadowtls/handshake/server" = { inherit sopsFile format; };
      "sing-box/shadowtls/password" = { inherit sopsFile format; };
      "sing-box/shadowtls/username" = { inherit sopsFile format; };
    };
  };
}
