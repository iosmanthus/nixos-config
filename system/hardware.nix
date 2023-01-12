{ ... }: {
  hardware.enableAllFirmware = true;

  hardware.pulseaudio.enable = true;

  # Enable bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.fwupd.enable = true;
}
