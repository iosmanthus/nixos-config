{
  stdenv,
  fetchFromGitHub,
  pkgs,
  ...
}:
stdenv.mkDerivation {
  pname = "kitty-themes";

  version = "unstable-2022-07-02";

  srcs = [
    (fetchFromGitHub {
      owner = "kdrag0n";
      repo = "base16-kitty";
      rev = "fe5862cec41bfd0b46a1ac3d7565a50680051226";
      sha256 = "096sa969z9v9w3ggsqd4d7gmqh52aavkmjhbz4zb35wq7fg5g5zs";
    })
    (fetchFromGitHub {
      repo = "gruvbox-material-kitty";
      owner = "iosmanthus";
      rev = "1dc12befe1022226a0e618e36cb26e58b3d248bb";
      sha256 = "0d7cl49z74l7v04sfwlpv76ihvckqn21v4i60hcv93x67x6xqaz5";
    })
  ];

  passthru = {
    mkKittyTheme = name: "${pkgs.kitty-themes}/colors/${name}.conf";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/colors
    for s in $srcs; do
      cp $s/*/*.conf $out/colors/
    done
  '';
}
