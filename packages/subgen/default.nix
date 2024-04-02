{ buildGoModule
}:

buildGoModule {
  pname = "subgen";

  version = "unstable-2023-12-15";

  src = ./.;

  vendorHash = "sha256-3FHiEFDSDr1KiEYAGWcdy6jgcasEMFh66Is7/6hbTFc=";
}
