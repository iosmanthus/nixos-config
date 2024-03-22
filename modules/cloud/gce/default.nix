{ self
, modulesPath
, ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/google-compute-image.nix"

    self.nixosModules.cloud.base
    self.nixosModules.nixbuild
  ];

  system.stateVersion = "24.05";
}
