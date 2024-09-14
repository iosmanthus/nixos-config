{ stdenv, ... }:
stdenv.mkDerivation {
  pname = "rime-data-cantonia";

  version = "unstable-2024-03-29";

  src = ./rime-data;
  installPhase = ''
    mkdir -p $out/share/rime-data
    cp -r $src/* $out/share/rime-data
  '';
}
