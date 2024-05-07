{ config
, ...
}: {
  users = {
    mutableUsers = false;
    users.${config.admin.name} = {
      inherit (config.admin) hashedPasswordFile shell;
      group = "users";
      isNormalUser = true;
      inherit (config.admin) home;
      description = config.admin.name;
      extraGroups =
        [
          "audio"
          "input"
          "storage"
          "video"
          "wheel"

          "adbusers"
          "docker"
          "libvirtd"
          "networkmanager"
          "tor"
          "wireshark"
        ];

      openssh.authorizedKeys.keys = [
        config.admin.sshPubKey
      ];
    };
  };
}
