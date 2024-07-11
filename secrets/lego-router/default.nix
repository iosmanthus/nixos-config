{ ... }:
{
  sops = {
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      sing-box-url = { };
      sing-box = {
        format = "binary";
        sopsFile = ./sing-box;
        restartUnits = [ "sing-box.service" ];
      };
    };
  };
}
