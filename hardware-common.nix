{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pavucontrol ];

  # Enable sound.
  services.blueman.enable = true;
  hardware.bluetooth = {
    #settings = { General = { ControllerMode = "bredr"; }; };
    enable = true;
    powerOnBoot = true;
  };

  services.gvfs.enable = true;
  security.rtkit.enable = true;
  hardware.enableAllFirmware = true;
  hardware.pulseaudio.enable = true;
  services.upower.enable = true;
}
