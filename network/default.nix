{ pkgs, ... }:
{
  imports = [
    ./tun2socks.nix
    ./openvpn.nix
  ];

  networking.hostName = "iosmanthus-nixos";
  networking = {
    nameservers = [ "172.18.0.1" ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
    passwordAuthentication = false;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAE0CpL+RLwnpBp1VzD3VUZpCEOIb1U+R6Jyu/SBq+Msg+CRlxfJThUJY4ZGwp6/d+VPWuQQHvvQ6OoLQdV5Pa9xZAFYOUEDWjAnD16gh29aoVDFzv+sDt2wyA4WZfqydrFSD9QhP88RpcGAcHZXCjzaGT1tEOw2wIOgGs6P53Mrti46Yw=="
  ];

  services.tun2socks = {
    enable = true;
    udp = {
      udpTimeout = 2;
    };
    socksProxy = "172.18.0.4:1080";
    ignoreSrcAddresses = [ "172.18.0.1/24" ];
  };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  services.tor = {
    enable = true;
    settings = {
      ControlPort = 9051;
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
      DataDirectoryGroupReadable = true;
    };
  };

  users.extraGroups.wireshark.members = [ "iosmanthus" ];
}
