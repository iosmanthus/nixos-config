{ pkgs
, config
, gpgKeysPath
, ...
}:
let
  importGPGKeys = pkgs.writeShellScript "import_gpg_keys" ''
    while [ ! -f "${config.programs.gpg.homedir}/pubring.kbx" ]; do
      sleep 1;
    done;
    mkdir -p "${config.programs.gpg.homedir}/private-keys-v1.d"
    ${pkgs.gnupg}/bin/gpg --import ${gpgKeysPath} 
  '';
in
{
  home.file = {
    "id_ecdsa_iosmanthus.pub" = {
      source = ./id_ecdsa_iosmanthus.pub;
      target = ".ssh/id_ecdsa_iosmanthus.pub";
    };
    "id_rsa_iosmanthus.pub" = {
      source = ./id_rsa_iosmanthus.pub;
      target = ".ssh/id_rsa_iosmanthus.pub";
    };
  };

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        # iosmanthus@myosmanthustree@gmail.com
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEYrLJyRYJKwYBBAHaRw8BAQdAobjfsICKRBRm8ZYn+3I+c+SMQ6qY++ExB3NL
          f6QJ+Bi0Jmlvc21hbnRodXMgPG15b3NtYW50aHVzdHJlZUBnbWFpbC5jb20+iJQE
          ExYKADwWIQS8SWFnaB5zjlmBSije5bqr/gkhaQUCYrLJyQIbAwUJA8JnAAQLCQgH
          BBUKCQgFFgIDAQACHgUCF4AACgkQ3uW6q/4JIWmgjAD/VQkxPYUlJChz20REbBDx
          hF/J+tRHlh8JwegHAOJaCyYA/i0p+NorkhfuBp1FZoFLZCHrPJKkx8tzR0BocaBO
          vN0LuDgEYrLJyRIKKwYBBAGXVQEFAQEHQAu9yMs4DzfKlaXU3T/vO+qbSacFTmcM
          D1MwrANUAR1uAwEIB4h+BBgWCgAmFiEEvElhZ2gec45ZgUoo3uW6q/4JIWkFAmKy
          yckCGwwFCQPCZwAACgkQ3uW6q/4JIWmC0AEAt/vPNVuNoE0U1notHrw2S6OX8a1z
          ALoLNAeo8OWJsSkBAN4Sqxo60PyuEiNy8vU+hr29fcVmGgDdxSwMV9biQ/kE
          =7n8X
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        trust = "ultimate";
      }
      {
        # iosmanthus@dengliming@pingcap.com
        text = ''
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mDMEYrKvORYJKwYBBAHaRw8BAQdAGW78sJ7dt94/KkmsDRPS70YxJaY6h4TR1xms
          CHIQF220I2lvc21hbnRodXMgPGRlbmdsaW1pbmdAcGluZ2NhcC5jb20+iJQEExYK
          ADwWIQRFaCMGw1GS/sPm+OrBazTgDc2K6QUCYrKvOQIbAwUJA8JnAAQLCQgHBBUK
          CQgFFgIDAQACHgUCF4AACgkQwWs04A3Niuk3jQEA3D2TqNYkfxrQpPBCpursiR2d
          PY0Zz2WhuqNxcH45k0QBAMi8FF8BELi8okCuRe1v2y11tT87fuPpej0ICFV9ybkK
          uDgEYrKvORIKKwYBBAGXVQEFAQEHQPn3ZLcxab3xNw7YJlmdW2UXZYEWegb6rQMJ
          QzmY4TRnAwEIB4h+BBgWCgAmFiEERWgjBsNRkv7D5vjqwWs04A3NiukFAmKyrzkC
          GwwFCQPCZwAACgkQwWs04A3NiukcXAEA8F7WhzbQ99Kd2kCigZjILeid5ewinfbj
          801vQUpgWfcBAPUhpnaQov8ks8paNDl3aSJG++oSeYT6++IYmb6zxLkB
          =tAmf
          -----END PGP PUBLIC KEY BLOCK-----
        '';
        trust = "ultimate";
      }
    ];
  };

  systemd.user.services = {
    import-gpg-keys = {
      Unit = {
        Description = "Import GPG secret keys";
      };
      Service = {
        Type = "simple";
        ExecStart = "${importGPGKeys}";
      };
    };
  };
}
