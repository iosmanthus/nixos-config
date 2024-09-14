{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
with lib;
rustPlatform.buildRustPackage {
  name = "leaf";

  src = fetchFromGitHub {
    owner = "iosmanthus";
    repo = "leaf";
    rev = "2f959902ef2fbd79980d9224ab83bc43b2e6f948";
    sha256 = "0a3b5jxq68f5xnl6xcbbn94q8samj6a3n1hhcp0qc1zv0y98q7fi";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "netstack-lwip-0.3.4" = "0gqc3pjra21ag70lf1qpbv5z4ibm14pmzby68a1j6axz8wd1d30b";
      "tun-0.5.1" = "0cr1p55wczzqmbpmzjpqjywzcamxwlgpfr71cr5jq8pf7n05sd27";
    };
  };

  meta = {
    description = "A versatile and efficient proxy framework with nice features suitable for various use cases.";
    homepage = "https://github.com/eycorsican/leaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ iosmanthus ];
  };
}
