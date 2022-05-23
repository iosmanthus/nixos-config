{ lib, stdenv, fetchurl, autoPatchelfHook }:
let
  inherit (stdenv.hostPlatform) system;
  supportedPlatform = {
    x86_64-linux = {
      alias = "linux-amd64";
      sha256 = "1150gyjp23mbs68czm53i7cbfpqnk62f8hqi1na7hq6zraqx640h";
    };
    x86_64-darwin = {
      alias = "darwin-amd64";
      sha256 = "0wwm7si0x9s362j671b5mmh4dcbadi1gg2a50xcz190p9w34xcxf";
    };
  };
in
stdenv.mkDerivation rec {
  name = "clash-premium";
  version = "2021.04.08";

  src = fetchurl {
    url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-${
        supportedPlatform.${system}.alias
      }-${version}.gz";
    sha256 = supportedPlatform.${system}.sha256;
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/clash-premium.gz
    gzip -d $out/bin/clash-premium.gz
    chmod +x $out/bin/clash-premium
  '';

  meta = with lib; {
    description = "A rule-based tunnel in Go.";
    homepage = "https://github.com/Dreamacro/clash";
    downloadPage = "https://github.com/Dreamacro/clash/releases/tag/premium";
    license = licenses.unfree;
    maintainers = with maintainers; [ iosmanthus ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
