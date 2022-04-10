{ config, ... }:

let
  v2rayImage = "teddysun/xray";

  v2rayTag = "1.5.4";

  geoVersion = "202204082211";

  geoip = builtins.fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${geoVersion}/geoip.dat";
    sha256 = "11nfharqsbz4swmlrzdf0qkqq5x77z29ry2qgg4x2nzcq1mq8dsp";
  };

  geosite = builtins.fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/${geoVersion}/geosite.dat";
    sha256 = "0bq2paj5116knb9ygyjhd9s4aq9z8qmhqyvi38frcrnmw9klbplj";
  };

  clashImage = "dreamacro/clash-premium";

  clashTag = "latest";

  mmdb = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb";
    sha256 = "199psf7q6f87mmg1jsnn1gkszmg16cv2wgi3pi7mbdjgyc6n7b2w";
  };

  networkName = "proxy";
in
{
  imports = [
    ./docker-network.nix
    ./v2ray.nix
    ./clash.nix
  ];

  services.docker-network = {
    "${networkName}" = {
      enable = true;
      subnet = "172.18.0.1/24";
      opts = {
        "com.docker.network.bridge.name" = "br-${networkName}";
      };
    };
  };

  virtualisation.v2ray-container = {
    enable = true;
    image = "${v2rayImage}:${v2rayTag}";

    configFile = config.sops.secrets.v2ray-config.path;

    inherit geoip geosite;

    extraOptions = [
      "--network=${networkName}"
      "--ip=172.18.0.2"
      "--dns=119.29.29.29"
    ];
  };

  virtualisation.clash-container = {
    enable = true;
    image = "${clashImage}:${clashTag}";

    configFile = config.sops.secrets.clash-config.path;

    inherit mmdb;

    extraOptions = [
      "--network=${networkName}"
      "--ip=172.18.0.3"
      "--dns=119.29.29.29"
    ];
  };

  virtualisation.oci-containers = {
    containers = {
      yacd = {
        image = "haishanh/yacd:latest";
        dependsOn = [
          "clash"
        ];
        extraOptions = [
          "--network=${networkName}"
          "--ip=172.18.0.4"
          "--dns=119.29.29.29"
        ];
      };
    };
  };
}
