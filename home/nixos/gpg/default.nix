{ pkgs, config, ... }:
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
  imports = [
    ../../base/gpg
  ];

  systemd.user.services = {
    import-gpg-keys = {
      Unit = {
        Description = "Import GPG secret keys";
        After = [ "sops-nix.service" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${importGPGKeys}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
