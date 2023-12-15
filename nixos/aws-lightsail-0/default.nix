{ pkgs
, modulesPath
, lib
, config
, ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"

    ./subgen
  ];

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-going = true
      download-attempts = 2
      connect-timeout = 5
    '';
    gc = {
      dates = "weekly";
      automatic = true;
      persistent = true;
      options = "--delete-older-than 2d";
    };
    settings = {
      auto-optimise-store = true;
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 2 * 1024; # 2 GiB
  }];

  environment.systemPackages = with pkgs; [
    dig
    git
    htop
    lsof
    vim
    wget
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  console = { keyMap = "us"; };

  time.timeZone = "Asia/Shanghai";

  system.stateVersion = "23.05";

  networking.firewall = {
    allowedTCPPorts = [ 10080 443 ];
    allowPing = false;
  };

  iosmanthus.sing-box = {
    enable = true;
    configFile = config.sops.templates."sing-box.json".path;
    restartTriggers = [ config.sops.templates."sing-box.json".content ];
  };

  iosmanthus.caddy = {
    enable = true;
    configFile = config.sops.templates."Caddyfile".path;
  };
}
