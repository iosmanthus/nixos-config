{ config, pkgs, ... }:
with pkgs;
let
  tunName = "tun0";
in
{
  sops.secrets.pingcap-ovpn = {
    format = "binary";
    sopsFile = ../secrets/pingcap.ovpn;
  };
  sops.secrets.pingcap-login = {
    format = "binary";
    sopsFile = ../secrets/pingcap-login.txt;
  };
  services.openvpn.servers = {
    pingcap = {
      config = ''
        dev ${tunName}
        auth-user-pass ${config.sops.secrets.pingcap-login.path}
        config ${config.sops.secrets.pingcap-ovpn.path}
      '';
    };
  };
}
