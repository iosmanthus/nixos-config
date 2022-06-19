{ stdenv
, fetchFromGitHub
}:
let
  pname = "clash-rules";
  version = "202206172240";
  src = fetchFromGitHub {
    owner = "Loyalsoldier";
    repo = pname;
    rev = "6e4248282f5a26aa68512c8d4fafae9c8060ed70";
    sha256 = "1s5pc7dx4958v3a9w5r0kvpb4j4zkynma1czdfc02l7ks4i51jcb";
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  installPhase = ''
    mkdir -p $out
    cp $src/*.txt $out/
  '';
}
