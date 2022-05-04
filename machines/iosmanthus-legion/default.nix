{ pkgs, ... }: {
  imports = [
    ../common
    ../iosmanthus.nix
    ./hardware-configuration.nix
    ./monitors.nix
  ];

  services.throttled = { enable = true; };
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
  # video driver
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
}
