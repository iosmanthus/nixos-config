{
  self,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/google-compute-image.nix"

    self.nixosModules.cloud.base
    self.nixosModules.cloud.firewall
    self.nixosModules.nixbuild
  ];

  system.stateVersion = "24.05";

  networking.interfaces.eth0.mtu = lib.mkForce 8896;
}
