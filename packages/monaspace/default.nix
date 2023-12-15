{ stdenv
, fetchFromGitHub
, ...
}:
let
  pname = "monaspace";
  version = "v1.000";
  src = fetchFromGitHub {
    owner = "githubnext";
    repo = "monaspace";
    rev = version;
    sha256 = "02x50kybw3b2g12x06rl9p3sqmhfbkz5hp0b35q0qbr88jppm3k6";
  };
in
stdenv.mkDerivation
{
  inherit pname version src;
  installPhase = ''
    mkdir -p $out/share/fonts/${pname}
    cp -rf $src/fonts/* $out/share/fonts/${pname}
  '';
}
