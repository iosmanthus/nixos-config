{ config
, pkgs
, ...
}: {
  users.mutableUsers = false;

  environment.pathsToLink = [ "/share/zsh" ];

  users.users.${config.machine.userName} = {
    hashedPassword = config.machine.hashedPassword;
    group = "users";
    shell = config.machine.shell;
    isNormalUser = true;
    home = "/home/${config.machine.userName}";
    description = "${config.machine.userName}";
    extraGroups =
      [ "wheel" "networkmanager" "video" "audio" "storage" "input" "tor" ];
  };

  services.udev = {
    extraRules = ''
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
    '';
  };

  users.users.root = { shell = pkgs.zsh; };

  security.pam.services.${config.machine.userName}.gnupg.enable = true;

  security.sudo.extraRules = [{
    users = [ "${config.machine.userName}" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
}
