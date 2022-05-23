{ fetchFromGitHub
, stdenv
, ...
}:

let
  name = "fcitx5-adwaita-dark";
  src = fetchFromGitHub {
    owner = "escape0707";
    repo = "fcitx5-adwaita-dark";
    rev = "1d45848312368595f3eeb9c246f203ca7032cbdd";
    sha256 = "16r1pzyykjxykpvrlpd5bwszpsr6wpvlxz44gfddhprgn16p3g83";
  };
in
stdenv.mkDerivation {
  inherit name src;
  installPhase = ''
    mkdir -p $out
    cp $src/*.png $src/*.conf $out/
  '';
}
