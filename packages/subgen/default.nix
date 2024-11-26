{ buildGoModule }:

buildGoModule {
  pname = "subgen";

  version = "unstable-2024-10-12";

  src = ./.;

  vendorHash = "sha256-O0SEq0dDEw8V3x5KmVh8LpeqciXX+CgZ3B0EB5rXPkA=";
}
