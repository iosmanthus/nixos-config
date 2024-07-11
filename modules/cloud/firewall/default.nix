{ lib
, ...
}: {
  services.fail2ban = {
    enable = true;
    daemonSettings = {
      Definition = {
        loglevel = "DEBUG";
      };
    };
    jails = {
      sshd = {
        settings = {
          filter = "sshd[mode=aggressive]";
          maxretry = 3;
          findtime = "24h";
          bantime = "365d";
        };
      };
    };
  };

  networking.firewall = {
    enable = lib.mkForce true;
    logRefusedConnections = true;
    checkReversePath = "loose";
  };
}
