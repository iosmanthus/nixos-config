{ pkgs
, config
, ...
}: {
  sops.secrets.id_ecdsa_iosmanthus = {
    format = "binary";
    sopsFile = ../secrets/id_ecdsa_iosmanthus;
    owner = "iosmanthus";
    path = "${config.users.users.iosmanthus.home}/.ssh/id_ecdsa_iosmanthus";
  };

  sops.secrets.id_rsa_iosmanthus = {
    format = "binary";
    sopsFile = ../secrets/id_rsa_iosmanthus;
    owner = "iosmanthus";
    path = "${config.users.users.iosmanthus.home}/.ssh/id_rsa_iosmanthus";
  };

  sops.secrets.ssh_config = {
    format = "binary";
    sopsFile = ../secrets/ssh_config;
    owner = "iosmanthus";
    path = "${config.users.users.iosmanthus.home}/.ssh/config";
  };
}
