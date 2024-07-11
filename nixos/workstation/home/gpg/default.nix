{ pkgs
, config
, ...
}:
let
  importGPGKeys = pkgs.writeShellScript "import_gpg_keys" ''
    while [ ! -f "${config.programs.gpg.homedir}/pubring.kbx" ]; do
      sleep 1;
    done;
    mkdir -p "${config.programs.gpg.homedir}/private-keys-v1.d"
    ${pkgs.gnupg}/bin/gpg --import ${config.sops.secrets.gpg-private.path} 
  '';
in
{
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      { source = ./0xDEE5BAABFE092169.gpg; trust = "ultimate"; }
      { source = ./0xC16B34E00DCD8AE9.gpg; trust = "ultimate"; }
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
      Install = {
        WantedBy = [ "sockets.target" ];
      };
    };
  };
}
