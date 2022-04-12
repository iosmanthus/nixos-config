{ pkgs
, stdenv
, ...
}:
stdenv.mkDerivation {
  name = "base16-rofi";
  src = pkgs.fetchFromGitHub {
    owner = "jordiorlando";
    repo = "base16-rofi";
    rev = "fbe876f7f75c25f27b6bc5b0572414827ee106b5";
    sha256 = "14868sfkxlcw1dz7msvvmsr95mzvv6av37wamssc5jaqjdpym8df";
  };
  buildCommand = ''
    mkdir -p $out/themes
    cp $src/themes/*.rasi $out/themes/
  '';
}
