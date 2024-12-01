{ ... }:
{
  sops = {
    secrets = {
      sing-box = {
        format = "binary";
        sopsFile = ./sing-box;
      };
    };
  };
}
