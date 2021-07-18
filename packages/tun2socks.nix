{ lib
, buildGoModule
, fetchFromGitHub
, ...
}:
buildGoModule {
  name = "tun2socks";
  version = "unstable-2021-05-31";

  src = fetchFromGitHub {
    owner = "xjasonlyu";
    repo = "tun2socks";
    rev = "67cc84d1d03c992e455ac1bb791fcfbf557d8348";
    sha256 = "sha256-0F14eg3/d4mo7BaER6teOwQ8QlNFh6APaXd9byw8Am0=";
  };

  vendorSha256 = "sha256-5DVoiQX7DSN1z0j6M/SYnKS+zR611U4Q/MxuYKNSG1U=";

  meta = with lib; {
    description = "tun2socks - powered by gVisor TCP/IP stack";
    homepage = "https://github.com/xjasonlyu/tun2socks";
    license = licenses.gpl3;
    maintainers = with maintainers; [ iosmanthus ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
