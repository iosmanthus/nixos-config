{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  services.throttled = { enable = true; };
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
}
