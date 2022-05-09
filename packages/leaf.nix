{ lib
, fetchgit
, rustPlatform
}:
with lib;
rustPlatform.buildRustPackage rec {
  name = "leaf";

  src = fetchgit {
    url = "https://github.com/iosmanthus/leaf.git";
    rev = "51c9e03ca1614b2f80deb8603f8bb2d25a417470";
    fetchSubmodules = true;
    sha256 = "1q9pmc8dx6jkvz48182x8bncmjb585d0l00pa9sdxhpby7ial9qz";
  };

  cargoSha256 = "06wl0abl1x4g8z0y9iqw2ch747skxmd0vka4kmhs9hs9x139bq0s";

  meta = {
    description = "A versatile and efficient proxy framework with nice features suitable for various use cases.";
    homepage = "https://github.com/eycorsican/leaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ iosmanthus ];
  };
}
