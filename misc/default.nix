{ pkgs
, ...
}: {
  i18n.defaultLocale = "en_US.UTF-8";
  console = { keyMap = "us"; };
  time.timeZone = "Asia/Shanghai";

  programs.zsh.enable = true;
  users.mutableUsers = false;
  users.users.iosmanthus = {
    hashedPassword =
      "$6$gR32JQgFbRXc8tU$McsRQyVYcImRhIajbCWxtte51jOZ8hf6h4Mk7WLap0.Bl9NNamdXUv9aRggBsibGGmp1SHVESVF1qLBl79l/c1";
    group = "users";
    shell = pkgs.zsh;
    isNormalUser = true;
    home = "/home/iosmanthus";
    description = "iosmanthus";
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

  security.pam.services.iosmanthus.gnupg.enable = true;

  security.sudo.extraRules = [{
    users = [ "iosmanthus" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];
}
