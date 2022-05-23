{ stdenv
, fetchFromGitHub
}:
stdenv.mkDerivation {
  version = "unstable-2020-05-12";
  pname = "base16-kitty";
  src = fetchFromGitHub {
    owner = "kdrag0n";
    repo = "base16-kitty";
    rev = "fe5862cec41bfd0b46a1ac3d7565a50680051226";
    sha256 = "+pdXnjuYl7E++QvKOrdSokBc32mkYf3e4Gmnn0xS2iQ=";
  };
  installPhase = ''
    mkdir -p $out/share/base16-kitty/colors
    cp -r $src/colors $out/share/base16-kitty
  '';
}
