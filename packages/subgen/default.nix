{ buildGoModule
}:

buildGoModule {
  pname = "subgen";

  version = "unstable-2024-05-20";

  src = ./.;

  vendorHash = "sha256-vsUugD4uf3XWseRS7YHmqvUOLqBthI8DCm9V64/8Fb4=";
}
