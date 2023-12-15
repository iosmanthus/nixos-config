{ buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "caddy";
  version = "unstable-2023-12-15";

  src = fetchFromGitHub {
    owner = "iosmanthus";
    repo = "caddy";
    rev = "18594d72a6636cb68e0c75450c10f44fd38af1f7";
    hash = "sha256-+z9v/CKEgEoDJWGH14VPNBD9q2/dHkvwPHdoOalrWqA=";
  };
  vendorHash = "sha256-sc1WsiSde7GKB+SSEHwQcGn08oq8MbtjlhBPV4VU5eg=";

  subPackages = [ "cmd/caddy" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${version}"
  ];
}
