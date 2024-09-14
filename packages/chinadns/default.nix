{ buildGoModule }:

buildGoModule {
  pname = "chinadns";

  version = "unstable-2024-07-08";

  src = ./.;

  vendorHash = "sha256-zLa6x7104wtLQt2vJ7M5xUosSzkkMpwe6EibdMMFafQ=";
}
