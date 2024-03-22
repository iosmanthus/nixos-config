{ self
, modulesPath
, lib
, ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"

    self.nixosModules.cloud.base
    self.nixosModules.nixbuild
  ];

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";

  system.stateVersion = "23.05";
}
