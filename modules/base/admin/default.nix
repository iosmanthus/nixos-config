{
  iosmanthus =
    { pkgs, config, ... }:
    {
      imports = [ ./options.nix ];

      admin = rec {
        name = "iosmanthus";
        email = "myosmanthustree@gmail.com";
        shell = pkgs.zsh;
        home = "/home/iosmanthus";
        hashedPasswordFile = config.sops.secrets."${name}/hashed-password".path;
        gpgPubKey = "0xDEE5BAABFE092169";
        sshPubKey = builtins.readFile ../../../secrets/iosmanthus/id_ecdsa_iosmanthus.pub;
      };
    };

  iosmanthus-darwin =
    { pkgs, ... }:
    {
      imports = [ ./options.nix ];

      admin = {
        name = "iosmanthus";
        email = "myosmanthustree@gmail.com";
        shell = pkgs.zsh;
        home = "/Users/iosmanthus";
        gpgPubKey = "0xDEE5BAABFE092169";
        sshPubKey = builtins.readFile ../../../secrets/iosmanthus/id_ecdsa_iosmanthus.pub;
      };
    };
}
