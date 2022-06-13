{ stdenv, fetchFromGitHub, ... }:
let
  pname = "segoe-ui";
  version = "unstable-2022-06-13";
  src = fetchFromGitHub {
    owner = "mrbvrz";
    repo = "segoe-ui-linux";
    rev = "02f6e1e9290581e7fc9bf3beefc0ebc9ec8c1611";
    sha256 = "1qvjq3sqn65cs5xhwjzwv74s0x6i09liz5faidk1p815vzn7qr6f";
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    install -m644 $src/font/*.ttf $out/share/fonts/truetype/
  '';
}
