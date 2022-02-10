{ pkgs
, ...
}:
{
  environment.systemPackages = with pkgs; [ pavucontrol ];
  hardware.enableAllFirmware = true;
  # video driver
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Enable sound.
  sound.enable = true;
  services.blueman.enable = true;
  hardware.bluetooth = {
    settings = {
      General = {
        ControllerMode = "bredr";
      };
    };
    enable = true;
    powerOnBoot = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.upower.enable = true;
  services.throttled = {
    enable = true;
  };
}
