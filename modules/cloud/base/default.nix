{ pkgs
, ...
}:
{
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

  # Enable BBR congestion control
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  swapDevices = [{
    device = "/swapfile";
    size = 2 * 1024; # 2 GiB
  }];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  services.journald = {
    extraConfig = ''
      SystemMaxUse=500M
      MaxRetentionSec=7d
    '';
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    dig
    fd
    git
    htop
    httpie
    jq
    lsof
    ripgrep
    vim
    wget
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  console = { keyMap = "us"; };

  time.timeZone = "Asia/Shanghai";
}
