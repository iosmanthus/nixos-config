{ config
, pkgs
, lib
, ...
}: {
  users.mutableUsers = false;

  environment.pathsToLink = lib.mkIf (config.machine.shell == pkgs.zsh)
    [ "/share/zsh" ];

  users.users.${config.machine.userName} = {
    inherit (config.machine) hashedPassword shell;
    group = "users";
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
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0180", MODE="0660", TAG+="uaccess"
    '';
  };

  security.pam.services.${config.machine.userName}.gnupg.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  security.sudo.extraRules = [{
    users = [ "${config.machine.userName}" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  security.polkit.enable = true;
}
