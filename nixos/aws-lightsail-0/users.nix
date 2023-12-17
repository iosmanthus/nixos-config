{ config
, ...
}: {
  users = {
    mutableUsers = false;
    users.${config.admin.name} = {
      inherit (config.admin) hashedPassword shell;
      group = "users";
      isNormalUser = true;
      inherit (config.admin) home;
      description = config.admin.name;
      extraGroups = [
        "storage"
        "wheel"
      ];

      openssh.authorizedKeys.keys = [
        config.admin.sshPubKey
      ];
    };
  };

  security = {
    sudo.extraRules = [{
      users = [ "${config.admin.name}" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
}
