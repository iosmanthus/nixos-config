{
  lib,
  config,
  pkgs,
  ...
}:
{
  networking = {
    nameservers = [
      "119.29.29.29"
      "223.5.5.5"
      "114.114.114.114"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  networking.firewall.enable = lib.mkForce false;

  networking.nftables.enable = true;

  services.self-hosted.sing-box = {
    enable = true;
    configFile = config.sops.secrets.sing-box.path;
  };
}
