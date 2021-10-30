{ pkgs, ... }:
with pkgs;
let
  pname = "polaybar-fonts";
  version = "unstable-2021-09-09";
  src = fetchFromGitHub {
    owner = "adi1090x";
    repo = "polybar-themes";
    rev = "46154c5283861a6f0a440363d82c4febead3c818";
    sha256 = "0lp1sqxzbc0w9df5jm0h7bkcdf94ahf4929vmf14y7yhbfy2llf3";
  };
in
stdenv.mkDerivation {
  inherit pname version src;
  installPhase = ''
    mkdir -p $out/share/fonts
    cp $src/fonts/feather.ttf $out/share/fonts/
    cp $src/fonts/material_design_iconic_font.ttf $out/share/fonts/
  '';
}
