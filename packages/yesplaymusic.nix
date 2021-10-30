{ pkgs, ... }:
with pkgs;
let
  pname = "yesplaymusic";
  version = "0.4.1";
  url = "https://github.com/qier222/YesPlayMusic/releases/download/v${version}/YesPlayMusic-${version}.AppImage";
  sha256 = "0bqybqkikr82mbwkyfb1ld6n9mi4mgcfcsry5jxxas15lraszx8d";
  src = builtins.fetchurl {
    inherit url sha256;
  };
  extracted = appimageTools.extractType2 {
    name = pname;
    inherit src;
  };
  wrapped = appimageTools.wrapType2 {
    name = pname;
    inherit src;
    extraPkgs = pkgs: with pkgs; [];
  };
  desktop = makeDesktopItem rec {
    name = "YesPlayMusic";
    desktopName = name;
    exec = "yesplaymusic";
    categories = "Audio;Player;";
    terminal = "false";
    icon = "${extracted}/yesplaymusic.png";
    comment = "YesPlayMusic Launcher";
    startupNotify = "true";
    extraEntries = ''
      StartupWMClass=${name}
    '';
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
