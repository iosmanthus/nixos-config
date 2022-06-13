{ stdenv, fetchFromGitHub, ... }:
let
  pname = "apple-fonts";
  version = "unstable-2022-06-14";
  src = fetchFromGitHub {
    owner = "perrychann";
    repo = "fonts";
    rev = "5708157c0901f036515c2674d9a4d7f3cf5a3450";
    sha256 = "0r0qdd4ji4z8vgp3gbw4x2s4jyqnkl7z2lgzj04pq6wfb526xih6";
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  installPhase = ''
    mkdir -p $out/share/fonts/apple/truetype
    install -m644 $src/'SF Pro'/*.otf $out/share/fonts/apple/truetype
    install -m644 $src/'PingFang SC'/* $out/share/fonts/apple/truetype
  '';
}
