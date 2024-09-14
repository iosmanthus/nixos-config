{ config, ... }:
let
  inherit (config.admin) home;
in
{
  home.file = {
    "id_ecdsa_iosmanthus.pub" = {
      source = ./id_ecdsa_iosmanthus.pub;
      target = ".ssh/id_ecdsa_iosmanthus.pub";
    };

    "id_rsa_iosmanthus.pub" = {
      source = ./id_rsa_iosmanthus.pub;
      target = ".ssh/id_rsa_iosmanthus.pub";
    };
  };

  sops.secrets.id-ecdsa-iosmanthus = {
    format = "binary";
    sopsFile = ./id_ecdsa_iosmanthus;
    path = "${home}/.ssh/id_ecdsa_iosmanthus";
  };

  sops.secrets.id-rsa-iosmanthus = {
    format = "binary";
    sopsFile = ./id_rsa_iosmanthus;
    path = "${home}/.ssh/id_rsa_iosmanthus";
  };

  sops.secrets.ssh-config = {
    format = "binary";
    sopsFile = ./ssh_config;
    path = "${home}/.ssh/config";
  };

  sops.secrets.nix-conf = {
    format = "binary";
    sopsFile = ./nix.conf;
    path = "${home}/.config/nix/nix.conf";
  };

  sops.secrets.gpg-private = {
    format = "binary";
    sopsFile = ./gpg_private_keys.asc;
  };

  sops.secrets.atuin-key = {
    format = "binary";
    sopsFile = ./atuin_key;
    path = "${home}/.local/share/atuin/key";
  };
}
