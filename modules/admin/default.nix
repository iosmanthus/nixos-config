{
  iosmanthus =
    { pkgs
    , config
    , ...
    }: {
      imports = [
        ./options.nix
      ];
      admin = rec {
        name = "iosmanthus";
        email = "myosmanthustree@gmail.com";
        shell = pkgs.zsh;
        home = "/home/iosmanthus";
        hashedPasswordFile = config.sops.secrets."${name}/hashed-password".path;
        gpgPubKey = "0xDEE5BAABFE092169";
        sshPubKey = ''
          ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAE0CpL+RLwnpBp1VzD3VUZpCEOIb1U+R6Jyu/SBq+Msg+CRlxfJThUJY4ZGwp6/d+VPWuQQHvvQ6OoLQdV5Pa9xZAFYOUEDWjAnD16gh29aoVDFzv+sDt2wyA4WZfqydrFSD9QhP88RpcGAcHZXCjzaGT1tEOw2wIOgGs6P53Mrti46Yw==
        '';
      };
    };
}
