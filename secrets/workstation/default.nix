{ config, ... }:
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      "${config.admin.name}/hashed-password" = {
        neededForUsers = true;
      };

      sing-box-url = { };

      sing-box = {
        format = "binary";
        sopsFile = ./sing-box;
        restartUnits = [ "sing-box.service" ];
      };
    };
  };
}
