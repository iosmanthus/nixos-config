{ lib, fetchgit, rustPlatform }:
with lib;
rustPlatform.buildRustPackage rec {
  name = "leaf";

  src = fetchgit {
    url = "https://github.com/iosmanthus/leaf.git";
    rev = "335ea3b0dd0ee9779c0d5d2cee70a187f813c082";
    fetchSubmodules = true;
    sha256 = "0wq3y341v0zi1x0prkwkwi23zckh32gcic10kcq8rw033grsvn6i";
  };

  cargoSha256 = "0y7fn7l8zff5ick0xh4rbnvv00cfl75sbq9071gb77i4k13yx4qg";

  meta = {
    description = "A versatile and efficient proxy framework with nice features suitable for various use cases.";
    homepage = "https://github.com/eycorsican/leaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ iosmanthus ];
  };
}
