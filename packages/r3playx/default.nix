{ pkgs, lib, ... }:
with pkgs;
let
  pname = "r3playx";
  # https://github.com/Sherlockouo/music/releases/download/2.7.5/R3PLAYX-2.7.5-linux-x86_64.AppImage
  version = "2.7.5";
  url = "https://github.com/Sherlockouo/music/releases/download/${version}/R3PLAYX-${version}-linux-x86_64.AppImage";
  sha256 = "161p3b0qq1bzrc9j8zczrjvna0iz8qwm3hl93yl4wh6dyxqrh6xd";
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
    name = "R3PLAYX";
    desktopName = name;
    exec = "r3playx";
    categories = [
      "Audio"
      "Player"
    ];
    terminal = false;
    icon = "${extracted}/desktop.png";
    comment = "R3PLAYX Launcher";
    startupNotify = true;
    startupWMClass = name;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = wrapped;
  installPhase = ''
    mkdir -p $out/bin
    cp ${src}/bin/r3playx $out/bin/r3playx
    install -D ${desktop}/share/applications/R3PLAYX.desktop $out/share/applications/R3PLAYX.desktop
  '';
  meta = with lib; {
    homepage = "https://github.com/qier222/YesPlayMusic";
    description = "A beautiful third-party player for NeteaseCloudMusic";
    license = licenses.mit;
  };
}
