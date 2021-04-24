{ lib, pkgs, stdenv }:
let
  inherit (stdenv.hostPlatform) system;
  supportedPlatform = {
    x86_64-linux = {
      alias = "linux-amd64";
      sha256 = "1akxsbib4fdkapl82pcihy2w69s22fb5p19n5j4vxxrhzq7887k1";
    };
    x86_64-darwin =
      {
        alias = "darwin-amd64";
        sha256 = "130m2glqclysc9yrc6bsac5fm0zlw905y96hqs0nw84i68bv18q1";
      };
  };
in
stdenv.mkDerivation rec {
  name = "clash-premium";
  version = "2021.03.10";

  src = fetchurl {
    url = "https://github.com/Dreamacro/clash/releases/download/premium/clash-${supportedPlatform.${system}.alias}-${version}.gz";
    sha256 = supportedPlatform.${system}.sha256;
  };

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
