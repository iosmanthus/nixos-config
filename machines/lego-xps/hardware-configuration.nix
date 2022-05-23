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

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/FF94-2C57";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/vm" =
    {
      device = "/dev/nvme0n1p3";
      fsType = "btrfs";
      options = [ "subvol=vm" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/4095d4a1-0598-43a0-b03c-d9bf6928236c"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
