# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config
, lib
, modulesPath
, ...
}:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/9fc68b4a-c446-4498-b9ae-6075ef52694f";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/home" =
    {
      neededForBoot = true;
      device = "/dev/disk/by-uuid/9fc68b4a-c446-4498-b9ae-6075ef52694f";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/vm" =
    {
      device = "/dev/disk/by-uuid/9fc68b4a-c446-4498-b9ae-6075ef52694f";
      fsType = "btrfs";
      options = [ "subvol=vm" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/17E6-15D0";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/727fdb7a-2c32-4626-9cd7-48f3515d02c8"; }];


  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
