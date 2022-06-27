{ lib
, fetchgit
, rustPlatform
}:
with lib;
rustPlatform.buildRustPackage rec {
  name = "leaf";

  src = fetchgit {
    url = "https://github.com/iosmanthus/leaf.git";
    rev = "9249b46ad536ffd2aef85eb5e27c3ba2cd63ddc7";
    fetchSubmodules = true;
    sha256 = "02i1zn0yzdw1q28bpj2hrsg35nqim7fdzhy6k1hcccr95hqhvxgh";
  };

  cargoSha256 = "06wl0abl1x4g8z0y9iqw2ch747skxmd0vka4kmhs9hs9x139bq0s";

  meta = {
    description = "A versatile and efficient proxy framework with nice features suitable for various use cases.";
    homepage = "https://github.com/eycorsican/leaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ iosmanthus ];
  };
}
