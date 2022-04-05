{ config, ... }:
let
  home = "${config.users.users.${config.machine.userName}.home}";
in
{
  sops.secrets.id_ecdsa_iosmanthus = {
    format = "binary";
    sopsFile = ./id_ecdsa_iosmanthus;
    owner = config.machine.userName;
    path = "${home}/.ssh/id_ecdsa_iosmanthus";
  };

  sops.secrets.id_rsa_iosmanthus = {
    format = "binary";
    sopsFile = ./id_rsa_iosmanthus;
    owner = config.machine.userName;
    path = "${home}/.ssh/id_rsa_iosmanthus";
  };

  sops.secrets.ssh_config = {
    format = "binary";
    sopsFile = ./ssh_config;
    owner = config.machine.userName;
    path = "${home}/.ssh/config";
  };
}
