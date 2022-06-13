{ lib
, stdenv
, ...
}:
let
  pname = "lxgw-wenkai";
  version = "1.235.2";
  url = "https://github.com/lxgw/LxgwWenKai/releases/download/v${version}/lxgw-wenkai-v${version}.tar.gz";
  sha256 = "17li3xry4j4ccdnwz2pcnf0gv7c5mwq0h5fwvl7ar28brn2qgdbk";
in
stdenv.mkDerivation {
  inherit pname version;

  src = builtins.fetchurl {
    inherit url sha256;
  };

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -m644 *.ttf $out/share/fonts/truetype
  '';

  meta = with lib; {
    maintainers = with maintainers; [ iosmanthus ];
    homepage = "https://github.com/lxgw/LxgwWenKai";
    description = "An open-source Chinese font derived from Fontworks' Klee One.";
    platforms = platforms.all;
    license = licenses.ofl;
  };
}
