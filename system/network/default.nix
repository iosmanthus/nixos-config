{ config
, pkgs
, ...
}: {
  imports = [
    ./proxy
    ./dns.nix
  ];

  dns = {
    servers = [
      "114.114.114.114"
      "119.29.29.29"
      "223.5.5.5"
    ];
  };

  networking = {
    nameservers = config.dns.servers;
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = false;
    };
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAE0CpL+RLwnpBp1VzD3VUZpCEOIb1U+R6Jyu/SBq+Msg+CRlxfJThUJY4ZGwp6/d+VPWuQQHvvQ6OoLQdV5Pa9xZAFYOUEDWjAnD16gh29aoVDFzv+sDt2wyA4WZfqydrFSD9QhP88RpcGAcHZXCjzaGT1tEOw2wIOgGs6P53Mrti46Yw=="
  ];

  users.users.${config.machine.userName}.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAE0CpL+RLwnpBp1VzD3VUZpCEOIb1U+R6Jyu/SBq+Msg+CRlxfJThUJY4ZGwp6/d+VPWuQQHvvQ6OoLQdV5Pa9xZAFYOUEDWjAnD16gh29aoVDFzv+sDt2wyA4WZfqydrFSD9QhP88RpcGAcHZXCjzaGT1tEOw2wIOgGs6P53Mrti46Yw=="
  ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  users.extraGroups.wireshark.members = [ "${config.machine.userName}" ];
}
