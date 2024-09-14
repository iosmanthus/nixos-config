{ ... }:
let
  sopsFile = ./secrets.json;
  format = "json";
in
{
  sops = {
    secrets = {
      "sing-box/shadowtls/username" = {
        inherit sopsFile format;
      };
      "sing-box/shadowtls/password" = {
        inherit sopsFile format;
      };
      "sing-box/shadowtls/server-name" = {
        inherit sopsFile format;
      };

      "sing-box/shadowsocks/users" = {
        inherit sopsFile format;
      };
      "sing-box/shadowsocks/method" = {
        inherit sopsFile format;
      };
      "sing-box/shadowsocks/server-password" = {
        inherit sopsFile format;
      };
      "sing-box/shadowsocks/default-user" = {
        inherit sopsFile format;
      };
    };
  };
}
