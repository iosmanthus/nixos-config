{ hostName, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ./monitors.nix
  ];

  networking = {
    inherit hostName;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    prime = {
      sync.enable = true;
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:02:0";
    };
  };
}
