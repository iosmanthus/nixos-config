{ buildGoModule }:

buildGoModule {
  pname = "unguarded";

  version = "unstable-2024-06-05";

  src = ./.;

  vendorHash = "sha256-yUMHgcg3stIUYaz38R0nVQQupuy6sx1ECUI5k2GHqSw=";
}
