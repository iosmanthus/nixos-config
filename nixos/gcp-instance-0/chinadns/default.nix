{ ... }:
{
  services.self-hosted.chinadns = {
    enable = true;
    geoipCN = ./geoip-cn.srs;
    geositeCN = ./geosite-china-list.srs;
    geositeNotCN = ./geosite-geolocation-not-cn.srs;
  };
}
