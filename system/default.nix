{ pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader = {
    systemd-boot = {
      consoleMode = "max";
      enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 3;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';
}
