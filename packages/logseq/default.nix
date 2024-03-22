{ pkgs
, lib
, ...
}:
with pkgs;
let
  pname = "logseq";
  version = "0.10.7";
  url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x64-${version}.AppImage";
  sha256 = "sha256-EC83D7tSpoDV6h363yIdX9IrTfoMd4b0hTVdW1T0pXg=";
  src = fetchurl { inherit url sha256; };
  extracted = appimageTools.extractType2 {
    name = pname;
    inherit src;
  };
  wrapped = appimageTools.wrapType2 {
    name = pname;
    inherit src;
    extraPkgs = _pkgs: [ ];
  };
  desktop = makeDesktopItem rec {
    name = "Logseq";
    desktopName = name;
    exec = "logseq";
    categories = [ "Development" ];
    terminal = false;
    icon = "${extracted}/resources/app/icons/logseq.png";
    startupNotify = true;
    startupWMClass = name;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;

  src = wrapped;

  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/logseq $out/bin/logseq
    install -D ${desktop}/share/applications/Logseq.desktop $out/share/applications/Logseq.desktop
  '';
}
