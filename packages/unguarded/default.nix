{ buildGoModule
}:

buildGoModule {
  pname = "unguarded";

  version = "unstable-2024-06-05";

  src = ./.;

  vendorHash = "sha256-6i/3DfytksLuz8tlenoBJ315q5bLy5PiE+c6b23hSd8=";
}
