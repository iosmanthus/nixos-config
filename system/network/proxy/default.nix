{ config
, ...
}:
{
  imports = [
    ./sing-box.nix
  ];

  services.sing-box = {
    enable = true;
    configFile = config.sops.secrets.sing-box.path;
    override = {
      "experimental" = {
        "clash_api" = {
          "cache_file" = "cache.db";
          "external_controller" = "127.0.0.1:7990";
          "store_selected" = true;
          "external_ui" = "./ui";
          "external_ui_download_detour" = "transits";
        };
      };
      "inbounds" = [
        {
          "tag" = "tun-in";
          "type" = "tun";
          "auto_route" = true;
          "strict_route" = true;
          "inet4_address" = "198.18.0.1/16";
          "interface_name" = "utun0";
          "sniff" = true;
          "stack" = "system";
        }
      ];
      "log" = {
        "level" = "debug";
        "timestamp" = false;
      };
    };
  };
}
