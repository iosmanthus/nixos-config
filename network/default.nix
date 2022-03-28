{ pkgs
, ...
}: {
  imports = [ ./ssh.nix ./tun2socks.nix ./proxy ];

  networking = {
    nameservers = [ "172.17.0.1" ];
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

  #networking.firewall.enable = false;
  services.tun2socks = {
    enable = true;
    proxy = {
      type = "socks5";
      address = "172.18.0.2:1080";
    };
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
      ExcludeNodes = "{cn},{hk},{mo}";
      StrictNodes = true;
    };
  };

  # services.docker-network = {
  #   test-net = {
  #     enable = true;
  #     subnet = "172.19.0.1/24";
  #     opts = {
  #       "com.docker.network.bridge.name" = "test-tun";
  #     };
  #   };
  # };

  users.extraGroups.wireshark.members = [ "iosmanthus" ];
}
