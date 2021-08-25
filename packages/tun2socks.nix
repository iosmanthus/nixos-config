{ lib
, buildGoModule
, fetchFromGitHub
, ...
}:
buildGoModule {
  name = "tun2socks";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = "tun2socks";
    rev = "bf59ddf897d128f47b6f2622f5aaef49caa33f33";
    sha256 = "3410cb374087f889dd3a394936c3ff65075f349c8b06c3311e73592ab9ecf98a";
  };

  vendorSha256 = "bb269a690c993d6e693f8c3ea45b7e979d947ca9c4433c9f9c5abf11f7871335";

  meta = with lib; {
    description = "tun2socks - powered by gVisor TCP/IP stack";
    homepage = "https://github.com/xjasonlyu/tun2socks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iosmanthus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
