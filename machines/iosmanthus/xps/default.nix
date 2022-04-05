{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./monitors.nix
    ../../common
  ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:02:0";
  };

  machine = {
    displayPort = "eDP-1-1";
  };
}
