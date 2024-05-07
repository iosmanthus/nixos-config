{ ... }:
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sing-box = {
        format = "binary";
        sopsFile = ./sing-box;
        restartUnits = [ "sing-box.service" ];
      };
    };
  };
}
