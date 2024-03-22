{ config
, lib
, ...
}: {
  security.sudo.wheelNeedsPassword = false;

  users.users.nixbuild = {
    name = "nixbuild";

    group = "users";

    isNormalUser = true;

    description = "nixbuild";

    extraGroups = [
      "wheel"
    ] ++ (if config.virtualisation.docker.enable then [ "docker" ] else [ ]);

    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../secrets/iosmanthus/id_ecdsa_iosmanthus.pub)
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "nixbuild"
  ];
}
