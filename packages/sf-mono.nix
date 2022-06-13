{ stdenv, fetchFromGitHub, ... }:
let
  pname = "sf-mono";
  version = "unstable-2022-06-14";
  src = fetchFromGitHub {
    owner = "supercomputra";
    repo = "SF-Mono-Font";
    rev = "1409ae79074d204c284507fef9e479248d5367c1";
    sha256 = "1yi3nqqs3lp6kkc2a5bvmmcq6j3ppkdmywsbiqcb79qyhhrvf0fz";
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  installPhase = ''
    mkdir -p $out/share/fonts/apple/truetype
    install -m644 $src/*.otf $out/share/fonts/apple/truetype
  '';
}