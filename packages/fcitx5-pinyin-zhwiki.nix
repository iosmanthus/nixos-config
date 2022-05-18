{ pkgs, ... }:
let
  name = "fcitx5-pinyin-zhwiki";
  version = "0.2.4";
  tag = "20220416";
  src = builtins.fetchurl {
    url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/${version}/zhwiki-${tag}.dict";
    sha256 = "1vygvx08ijcbdif3g341cab2ax0gn7q42cb8849179azr34yqaxz";
  };
in
pkgs.stdenv.mkDerivation {
  inherit name version src;
  dontUnpack = true;
  installPhase = ''
    cp $src $out
  '';
}
