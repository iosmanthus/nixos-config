{
  config,
  pkgs,
  hostName,
  ...
}:
{
  imports = [
    ./aerospace
    ./homebrew
    ./system
  ];

  sops.age.keyFile = "${config.admin.home}/.config/sops/age/keys.txt";

  environment.variables = {
    SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
  };

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };

  networking = {
    knownNetworkServices = [
      "Wi-Fi"
      "Ethernet Adaptor"
      "Thunderbolt Ethernet"
    ];
    dns = [
      "223.5.5.5"
      "114.114.114.114"
      "119.29.29.29"
    ];
  };

  nix = {
    package = pkgs.nixVersions.nix_2_22;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-going = true
      download-attempts = 2
      connect-timeout = 5
    '';
    optimise = {
      automatic = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
    };
  };

  programs.zsh.enable = true;
  networking = {
    inherit hostName;
    computerName = hostName;
  };

  users.users.${config.admin.name} = {
    inherit (config.admin) shell home;
    description = config.admin.name;
    openssh.authorizedKeys.keys = [ config.admin.sshPubKey ];
  };

  nix.settings.trusted-users = [ config.admin.name ];

  services.sing-box = {
    enable = true;
    configPath = config.sops.secrets.sing-box.path;
  };
}
