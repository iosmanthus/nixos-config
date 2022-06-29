{ config
, pkgs
, ...
}:
let
  v2rayImage = "teddysun/xray";

  v2rayImageFile = pkgs.dockerTools.pullImage {
    imageName = "${v2rayImage}";
    imageDigest = "sha256:174797b48525450ba8dbabfa667cc23e398d0e35c812e6cf0a81583695bde606";
    sha256 = "1im9xyf3r40scp44bzglsqdlilkrck9405izfpyzy6kmxs3sq0wb";
  };

  clashImage = "dreamacro/clash-premium";

  clashImageFile = pkgs.dockerTools.pullImage {
    imageName = "${clashImage}";
    imageDigest = "sha256:550f4edca1b0420c45dfb32f62ebf65150c9660da1b9468bf4cdcc7c4d01b0fc";
    sha256 = "1zsbsz7i7nqg7x7cm22wgg8hnxdl28ypm5za1pfh3951q90x1wmf";
  };

  yacdImage = "haishanh/yacd";

  yacdImageFile = pkgs.dockerTools.pullImage {
    imageName = "${yacdImage}";
    imageDigest = "sha256:4a9d0f286b2d48887628507df7d2090660c9211c7526fb1a1808130298cc30e8";
    sha256 = "14nyb2vq124cj4dg1ks6y307qch6vdpfcnc8xjfiawghjyvw51dp";
  };

  networkName = "proxy";
  environment = {
    TZ = config.time.timeZone;
  };
in
{
  imports = [
    ./leaf-tun.nix
    ./docker-network.nix
  ];

  services.leaf-tun = {
    enable = true;

    tcpProxy = {
      type = "socks";
      address = "172.18.0.3";
      port = 1080;
    };

    udpProxy = {
      type = "socks";
      address = "172.18.0.2";
      port = 1080;
    };

    tun = {
      name = "utun8";
      fakeDnsExclude = [ "pingcap.net" "ntp" "keyserver.ubuntu.com" ];
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
        workdir = "/var/run/v2ray";
        cmd = [ "xray" "run" "-confdir" "./" ];
        volumes = [
          "${config.sops.secrets.v2ray-config.path}:${workdir}/config.json"
        ];
        inherit environment;
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
        workdir = "/var/run/clash";
        cmd = [ "-d" "./" ];
        volumes = [
          "${config.sops.secrets.clash-config.path}:${workdir}/config.yaml"
          "${pkgs.clash-rules}:${workdir}/ruleset"
          "${pkgs.mmdb}:${workdir}/Country.mmdb"
          "${config.users.users.${config.machine.userName}.home}/.cache/clash:${workdir}"
        ];
        inherit environment;
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
        inherit environment;
        extraOptions = [
          "--network=${networkName}"
          "--ip=172.18.0.4"
          "--dns=119.29.29.29"
        ];
      };
    };
  };
}
