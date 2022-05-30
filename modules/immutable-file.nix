{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.home.immutable-file;
  immutableFileOpts = { ... }: {
    options = {
      src = mkOption {
        type = types.path;
      };
      dst = mkOption {
        type = types.path;
      };
    };
  };
  mkImmutableFile = pkgs.writeScript "make_immutable_file" ''
    if [ ! -d "$(dirname $dst)" ]; then
      mkdir -p $dst
    fi

    if [ -f $1 ]; then
        sudo chattr -i $1
    fi

    sudo cp $2 $1
    sudo chattr +i $1
  '';
in
{
  options.home.immutable-file = mkOption {
    type = with types; attrsOf (submodule immutableFileOpts);
    default = { };
  };

  config = mkIf (cfg != { }) {
    home.activation = mapAttrs'
      (name: { src, dst }:
        nameValuePair
          "make-immutable-${name}"
          (lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            ${mkImmutableFile} ${dst} ${src}
          ''))
      cfg;
  };
}
