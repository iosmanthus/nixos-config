{ config, ... }:
let
  home = "${config.users.users.${config.machine.userName}.home}";
in
{
  sops.secrets.id-ecdsa-iosmanthus = {
    format = "binary";
    sopsFile = ./id_ecdsa_iosmanthus;
    owner = config.machine.userName;
    path = "${home}/.ssh/id_ecdsa_iosmanthus";
  };

  sops.secrets.id-rsa-iosmanthus = {
    format = "binary";
    sopsFile = ./id_rsa_iosmanthus;
    owner = config.machine.userName;
    path = "${home}/.ssh/id_rsa_iosmanthus";
  };

  sops.secrets.ssh-config = {
    format = "binary";
    sopsFile = ./ssh_config;
    owner = config.machine.userName;
    path = "${home}/.ssh/config";
  };

  sops.secrets.v2ray-config = {
    format = "binary";
    sopsFile = ./v2ray_config;
  };

  sops.secrets.clash-config = {
    format = "binary";
    sopsFile = ./clash_config;
  };
}
