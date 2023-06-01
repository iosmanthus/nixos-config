{ ... }:
let
  hashFiles = builtins.map (builtins.hashFile "sha256");
in
{
  sops.secrets.sing-box = {
    format = "binary";
    sopsFile = ./sing-box;
  };

  systemd.services.sing-box.restartTriggers = hashFiles [
    ./sing-box
  ];
}
