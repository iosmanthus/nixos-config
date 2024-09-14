{ config
, ...
}: {
  virtualisation.docker.enable = true;

  services.self-hosted.o11y = {
    enable = true;
    hostName = "gcp-instance-2";
  };

  services.self-hosted.cloud.sing-box = {
    enable = true;
    unlockSettings = {
      server = {
        tag = "hq";
        type = "shadowsocks";
        server = config.sops.placeholder."gcp-instance-0/external-address-v4";
        server_port = 18080;
        method = config.sops.placeholder."sing-box/shadowsocks/method";
        password =
          "${config.sops.placeholder."sing-box/shadowsocks/server-password"}:${config.sops.placeholder."sing-box/shadowsocks/default-user"}";
        multiplex = {
          enabled = true;
          padding = true;
        };
      };
      sites = builtins.map
        (geosite: "geosite-${geosite}")
        [
          "category-porn"
          "cloudflare"
          "disney"
          "google"
          "hbo"
          "hulu"
          "microsoft"
          "netflix"
          "openai"
          "stripe"
          "tiktok"
          "youtube"
        ];
    };
  };
}
