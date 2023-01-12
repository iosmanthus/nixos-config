{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./desktop
    ./network

    ./hardware.nix
    ./security.nix
    ./virtualisation.nix
    ./monitoring.nix
  ];

  # nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

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
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = { keyMap = "us"; };

  time.timeZone = "Asia/Shanghai";

  sops.age.keyFile =
    "${config.users.users.${config.machine.userName}.home}/.config/sops/age/keys.txt";

  environment.systemPackages = with pkgs; [
    lsof
    wget
    neovim
    file
    git
    bind
    lm_sensors
  ];

  environment.etc = {
    "nixos/flake.nix".source = config.users.users.${config.machine.userName}.home
      + "/nixos-config/flake.nix";
  };

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    systemd-boot = {
      consoleMode = "max";
      enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.kernel.sysctl = { "net.ipv4.tcp_fastopen" = 3; };

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=5s
  '';

  services.journald = {
    extraConfig = ''
      SystemMaxUse=1G
    '';
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
  };

  services.gnome.gnome-keyring.enable = true;

  # Enable blueman.
  services.blueman.enable = true;

  services.gvfs.enable = true;

  security.rtkit.enable = true;

  services.upower.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
