{ lib, fetchgit, rustPlatform }:
with lib;
rustPlatform.buildRustPackage rec {
  name = "leaf";

  src = fetchgit {
    url = "https://github.com/iosmanthus/leaf.git";
    rev = "3d31b6d6303babeb44f53aaf79b3a8e31becabb2";
    fetchSubmodules = true;
    sha256 = "06il9kf4bmgjav5jqbr0a2d8mgdyhjyah5snb2cgyc3xnrmxpkji";
  };

  cargoSha256 = "0wr26r3vj3qf2iyf1gjgrwyws50537mgb4y9gf4yb8fmclyqsxp4";

  meta = {
    description = "A versatile and efficient proxy framework with nice features suitable for various use cases.";
    homepage = "https://github.com/eycorsican/leaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ iosmanthus ];
  };
}
