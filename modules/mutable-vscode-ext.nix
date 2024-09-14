{ config, lib, ... }:
with lib;
let
  cfg = config.programs.vscode.mutableExtensions;
  extensions = {
    options = {
      name = mkOption { type = types.str; };
      publisher = mkOption { type = types.str; };
      version = mkOption { type = types.str; };
    };
  };
in
{
  options.programs.vscode.mutableExtensions = mkOption {
    type = types.listOf (types.submodule extensions);
  };
  config = mkIf (config.programs.vscode.enable && config.programs.vscode.mutableExtensionsDir) {
    home.activation = {
      installMutableExtensions = hm.dag.entryAfter [ "writeBoundary" ] ''
        exts=(${
          toString (
            builtins.map (
              {
                publisher,
                name,
                version,
              }:
              "${publisher}.${name}@${version}"
            ) cfg
          )
        })
        CODE=$(command -v code || command -v codium || command -v code-insiders)
        for ext in $(echo $exts | sed 's/ /\n/g'); do
          $CODE --install-extension $ext
        done
      '';
    };
  };
}
