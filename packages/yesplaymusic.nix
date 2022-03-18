{ pkgs
, lib
, ...
}:
with pkgs;
let
  pname = "yesplaymusic";
  version = "0.4.4";
  tag = "beta.1";
  releaseVersion = if tag != "" then "${version}-${tag}" else version;
  url =
    "https://github.com/qier222/YesPlayMusic/releases/download/v${releaseVersion}/YesPlayMusic-${version}.AppImage";
  sha256 = "0940nj89ca0rxx1958319zj42z2dv4rr0249shafs5jf37xanwb7";
  src = builtins.fetchurl { inherit url sha256; };
  extracted = appimageTools.extractType2 {
    name = pname;
    inherit src;
  };
  wrapped = appimageTools.wrapType2 {
    name = pname;
    inherit src;
    extraPkgs = pkgs: with pkgs; [ ];
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
    ls ${src}/bin
    cp ${src}/bin/* $out/bin
    install -D ${desktop}/share/applications/YesPlayMusic.desktop $out/share/applications/YesPlayMusic.desktop
  '';
  meta = with lib; {
    homepage = "https://github.com/qier222/YesPlayMusic";
    description = "A beautiful third-party player for NeteaseCloudMusic";
    license = licenses.mit;
  };
}
