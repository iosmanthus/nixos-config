{ lib
, config
, ...
}:
let
  user = "${config.machine.userName}";
  home = "${config.users.users.${user}.home}";
  gpgKeysPath = config.sops.secrets.gpg-private.path;
in
{
  home-manager.users.${user} = (
    { lib, config, pkgs, ... }: import ./home.nix {
      inherit lib config pkgs gpgKeysPath;
    }
  );

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

  sops.secrets.nix-conf = {
    format = "binary";
    sopsFile = ./nix.conf;
    owner = config.machine.userName;
    path = "${home}/.config/nix/nix.conf";
  };

  sops.secrets.gpg-private = {
    format = "binary";
    owner = config.machine.userName;
    sopsFile = ./gpg_private_keys.asc;
  };
}
