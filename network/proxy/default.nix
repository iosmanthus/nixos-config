{ config
, pkgs
, ...
}:
let
  v2rayImage = "teddysun/xray";

  v2rayImageFile = pkgs.dockerTools.pullImage {
    imageName = "${v2rayImage}";
    imageDigest = "sha256:3765e7940f414d4ebbf1eb5f4f624c60cc92212737bca68ff5fdb18b1371dfd2";
    sha256 = "166mhlyismfpyp15dv1zcnwfby3n72ckfz71j57d5q2qrylg0jc1";
  };

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

  clashImageFile = pkgs.dockerTools.pullImage {
    imageName = "${clashImage}";
    imageDigest = "sha256:550f4edca1b0420c45dfb32f62ebf65150c9660da1b9468bf4cdcc7c4d01b0fc";
    sha256 = "1zsbsz7i7nqg7x7cm22wgg8hnxdl28ypm5za1pfh3951q90x1wmf";
  };

  mmdb = builtins.fetchurl {
    url = "https://cdn.jsdelivr.net/gh/Dreamacro/maxmind-geoip@release/Country.mmdb";
    sha256 = "199psf7q6f87mmg1jsnn1gkszmg16cv2wgi3pi7mbdjgyc6n7b2w";
  };

  clashConfig = config.sops.secrets.clash-config.path;

  yacdImage = "haishanh/yacd";

  yacdImageFile = pkgs.dockerTools.pullImage {
    imageName = "${yacdImage}";
    imageDigest = "sha256:4a9d0f286b2d48887628507df7d2090660c9211c7526fb1a1808130298cc30e8";
    sha256 = "14nyb2vq124cj4dg1ks6y307qch6vdpfcnc8xjfiawghjyvw51dp";
  };

  networkName = "proxy";
in
{
  imports = [
    ./leaf-tun.nix
    ./docker-network.nix
  ];

  services.leaf-tun = {
    enable = true;
    proxy = {
      type = "socks";
      address = "172.18.0.2";
      port = 1080;
    };
    tun = {
      name = "utun8";
    };
    ignoreSrcAddresses = [ "172.18.0.1/24" ];
  };


  services.docker-network = {
    "${networkName}" = {
      enable = true;
      subnet = "172.18.0.1/24";
      opts = {
        "com.docker.network.bridge.name" = "br-${networkName}";
      };
    };
  };

  virtualisation.oci-containers = {
    containers = {
      v2ray = rec {
        image = v2rayImage;
        imageFile = v2rayImageFile;
        workdir = "/etc/v2ray";
        cmd = [ "xray" "run" "-confdir" "./" ];
        volumes = [
          "${config.sops.secrets.v2ray-config.path}:${workdir}/config.json"
          "${geoip}:${workdir}/geoip.dat"
          "${geosite}:${workdir}/geosite.dat"
        ];
        extraOptions = [
          "--network=${networkName}"
          "--ip=172.18.0.2"
          "--dns=119.29.29.29"
        ];
        dependsOn = [
          "clash"
        ];
      };
      clash = rec {
        image = clashImage;
        imageFile = clashImageFile;
        workdir = "/etc/clash";
        cmd = [ "-d" "./" ];
        volumes = [
          "${clashConfig}:${workdir}/config.yaml"
          "${mmdb}:${workdir}/Country.mmdb"
        ];
        extraOptions = [
          "--network=${networkName}"
          "--ip=172.18.0.3"
          "--dns=119.29.29.29"
        ];
      };
      yacd = {
        image = yacdImage;
        imageFile = yacdImageFile;
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
