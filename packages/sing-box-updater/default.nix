{ buildGoModule
}:

buildGoModule {
  pname = "sing-box-updater";

  version = "unstable-2024-07-04";

  src = ./.;

  vendorHash = "sha256-9opHaJ2lxEzKA59KscPGIdfpCdiQmEHdILWIvlGx+G0=";
}
