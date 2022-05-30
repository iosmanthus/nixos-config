{ config
, pkgs
, ...
}: {
  imports = [
    ./proxy
  ];

  networking = {
    nameservers = [ "119.29.29.29" ];
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

  users.users.${config.machine.userName}.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAE0CpL+RLwnpBp1VzD3VUZpCEOIb1U+R6Jyu/SBq+Msg+CRlxfJThUJY4ZGwp6/d+VPWuQQHvvQ6OoLQdV5Pa9xZAFYOUEDWjAnD16gh29aoVDFzv+sDt2wyA4WZfqydrFSD9QhP88RpcGAcHZXCjzaGT1tEOw2wIOgGs6P53Mrti46Yw=="
  ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  services.tor = {
    enable = true;
    client.enable = true;
    settings = {
      ControlPort = 9051;
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
      DataDirectoryGroupReadable = true;
      ExcludeNodes = "{cn},{hk},{mo}";
      StrictNodes = true;
    };
  };

  users.extraGroups.wireshark.members = [ "${config.machine.userName}" ];
}
