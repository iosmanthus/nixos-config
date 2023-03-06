{ lib
, modulesPath
, ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "coretemp" "cpuid" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/nvme1n1p2";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/home" = {
    neededForBoot = true;
    device = "/dev/nvme1n1p2";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/vbox" = {
    device = "/dev/nvme1n1p2";
    fsType = "btrfs";
    options = [ "subvol=vbox" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/23D3-8DE0";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/9f505500-071c-48b1-9561-467ee3657124"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
