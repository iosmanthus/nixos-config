{ config, ... }:
{
  users = {
    mutableUsers = false;
    users.${config.admin.name} = {
      inherit (config.admin) hashedPasswordFile shell;
      group = "users";
      isNormalUser = true;
      inherit (config.admin) home;
      description = config.admin.name;

      extraGroups = [
        "docker"
        "storage"
        "wheel"
      ];

      openssh.authorizedKeys.keys = [ config.admin.sshPubKey ];
    };
  };
}
