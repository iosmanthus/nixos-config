{ lib
, buildGoModule
, fetchFromGitHub
, ...
}:
buildGoModule {
  name = "tun2socks";
  version = "master";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = "tun2socks";
    rev = "3f7fdc1d83ea3ce13510e2443727038bc9aafe19";
    sha256 = "10898m6pkdpjwr9q24hckwgh72djfc2n49zf5lsa7ysg0kv7n941";
  };

  vendorSha256 = "0vq0rw7ddk2iyrasbgs28k8aq257lhli9wfxw534xlsfdhclzasy";

  meta = with lib; {
    description = "tun2socks - powered by gVisor TCP/IP stack";
    homepage = "https://github.com/xjasonlyu/tun2socks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iosmanthus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
