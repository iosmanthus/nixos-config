{ pkgs
, lib
, ...
}:
with pkgs;
let
  pname = "yesplaymusic";
  version = "2.0.0";
  url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}-alpha-2/R3PLAY-${version}-linux.AppImage";
  sha256 = "1ivyjafqib9367bzcipabf4ysghcyb3fh1xd9kfzw9wcbz1bs231";
  src = builtins.fetchurl { inherit url sha256; };
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
    name = "YesPlayMusic";
    desktopName = name;
    exec = "yesplaymusic";
    categories = [ "Audio" "Player" ];
    terminal = false;
    icon = "${extracted}/yesplaymusic.png";
    comment = "YesPlayMusic Launcher";
    startupNotify = true;
    startupWMClass = name;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = wrapped;
  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/* $out/bin
    install -D ${desktop}/share/applications/YesPlayMusic.desktop $out/share/applications/YesPlayMusic.desktop
  '';
  meta = with lib; {
    homepage = "https://github.com/qier222/YesPlayMusic";
    description = "A beautiful third-party player for NeteaseCloudMusic";
    license = licenses.mit;
  };
}
