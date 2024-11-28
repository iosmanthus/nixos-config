{
  pkgs,
  config,
  ...
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
  launchd.agents.import-gpg-keys = {
    enable = true;
    config = {
      ProgramArguments = [ "${importGPGKeys}" ];
      KeepAlive = {
        Crashed = false;
        SuccessfulExit = false;
      };
      RunAtLoad = true;
    };
  };
}
