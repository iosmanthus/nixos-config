{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./monitors.nix
    ../../common
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

  machine = {
    displayPort = "eDP-1";
  };
}
