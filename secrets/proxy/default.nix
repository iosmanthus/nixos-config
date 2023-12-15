{ ... }:
{
  sops.secrets.sing-box = {
    format = "binary";
    sopsFile = ./sing-box;
    restartUnits = [ "iosmanthus-sing-box.service" ];
  };
}
