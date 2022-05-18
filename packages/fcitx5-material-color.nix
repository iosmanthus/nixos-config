{ pkgs
, themeVariant ? "black"
, ...
}:

let
  name = "fcitx5-material-color";
  src = pkgs.fetchFromGitHub {
    owner = "hosxy";
    repo = "Fcitx5-Material-Color";
    rev = "2256feeae48dcc87f19a3cfe98f171862f8fcace";
    sha256 = "0drdypjf1njl7flkb5d581vchwlp4gaqyws3cp0v874wkwh4gllb";
  };
in
pkgs.stdenv.mkDerivation {
  inherit name src;
  installPhase = ''
    mkdir -p $out
    cp $src/*.png $out/
    cp $src/theme-${themeVariant}.conf $out/theme.conf
  '';
}
