{ pkgs
, ...
}:
{
  imports = [
    ../common
    ./hardware-configuration.nix
    ./monitors.nix
  ];

  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
  # video driver
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];
}
