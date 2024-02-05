{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./desktop

    ./network.nix
    ./users.nix
  ];

  # nixpkgs configuration
  nixpkgs.config.allowUnfree = true;

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "20.09";
  };

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
    settings = {
      auto-optimise-store = true;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
      ];
    };
  };

  console = { keyMap = "us"; };

  time.timeZone = "Asia/Shanghai";

  sops.age.keyFile =
    "${config.admin.home}/.config/sops/age/keys.txt";

  environment.systemPackages = with pkgs; [
    alsa-utils
    bind
    fd
    file
    git
    killall
    lm_sensors
    lsof
    neovim
    ripgrep
    wget

    docker-compose
    virt-manager
    virt-viewer
  ];

  programs.zsh.enable = true;

  environment = {
    etc = {
      "nixos/flake.nix".source = config.users.users.${config.admin.name}.home
        + "/nixos-config/flake.nix";
    };

    pathsToLink = lib.mkIf (config.admin.shell == pkgs.zsh) [ "/share/zsh" ];
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    loader = {
      systemd-boot = {
        consoleMode = "max";
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      "net.ipv4.tcp_fastopen" = 3;
    };
  };

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
  services.fwupd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.blueman.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;
  services.udev = {
    packages = with pkgs; [
      via
    ];
    extraRules = ''
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/intel_backlight/brightness"
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/intel_backlight/brightness"
    '';
  };
  services.printing = {
    enable = true;
    drivers = with pkgs; [ hplip ];
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo.extraRules = [{
      users = [ "${config.admin.name}" ];
      commands = [{
        command = "ALL";
        options = [ "NOPASSWD" ];
      }];
    }];
    pam = {
      services = {
        ${config.admin.name}.gnupg.enable = true;
        lightdm.enableGnomeKeyring = true;
      };
    };
  };

  hardware = {
    enableAllFirmware = true;
    pulseaudio.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      extraOptions = ''
        --default-ulimit nofile=1048576:1048576 --bip "172.17.0.1/24" --storage-driver btrfs
      '';
    };
    libvirtd = { enable = true; };
    spiceUSBRedirection.enable = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs;  [
      acl
      attr
      bzip2
      curl
      expat
      fuse3
      icu
      libsodium
      libssh
      libxml2
      nss
      openssl
      stdenv.cc.cc
      systemd
      util-linux
      xz
      zlib
      zstd
    ];
  };
}
