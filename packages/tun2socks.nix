{ lib
, buildGo117Module
, fetchFromGitHub
, ...
}:
buildGo117Module rec {
  name = "tun2socks";
  version = "2.3.2";
  overrideModAttrs = _oldAttrs: {
    GOPROXY = "https://goproxy.cn,direct";
    GO111MODULE = "on";
  };

  proxyVendor = true;

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = "tun2socks";
    rev = "v${version}";
    sha256 = "1p8hifl30zq80k16240c8ssaab3mi1c4j9i0rirlv6algj8zzd9s";
  };

  vendorSha256 = "08xc1kgri8vi4mlhkjhaxl20ld4km7fydmfdsrfh0sjs656vzg1h";

  meta = with lib; {
    description = "tun2socks - powered by gVisor TCP/IP stack";
    homepage = "https://github.com/xjasonlyu/tun2socks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iosmanthus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
