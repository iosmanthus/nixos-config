{ config, lib, pkgs, ... }:
with lib;
{
  options.services.xserver.displayManager.gdm.extraConfig = {
    tapping = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = let
    cfg = config.services.xserver.displayManager.gdm;
  in
    mkIf cfg.enable {
      # I can't find a way to merge multiple dconf profiles. qaq
      programs.dconf.profiles.gdm =
        let
          gdm = pkgs.gnome.gdm;
          customDconf = pkgs.writeTextFile {
            name = "gdm-dconf";
            destination = "/dconf/gdm-custom";
            text = ''
              ${optionalString (!cfg.autoSuspend) ''
              [org/gnome/settings-daemon/plugins/power]
              sleep-inactive-ac-type='nothing'
              sleep-inactive-battery-type='nothing'
              sleep-inactive-ac-timeout=0
              sleep-inactive-battery-timeout=0
            ''}
              [org/gnome/desktop/peripherals/touchpad]
              tap-to-click=${boolToString cfg.extraConfig.tapping}
            '';
          };

          customDconfDb = pkgs.stdenv.mkDerivation {
            name = "gdm-dconf-db";
            buildCommand = ''
              ${pkgs.dconf}/bin/dconf compile $out ${customDconf}/dconf
            '';
          };
        in
          mkForce (
            pkgs.stdenv.mkDerivation {
              name = "dconf-gdm-profile";
              buildCommand = ''
                # Check that the GDM profile starts with what we expect.
                if [ $(head -n 1 ${gdm}/share/dconf/profile/gdm) != "user-db:user" ]; then
                  echo "GDM dconf profile changed, please update gdm.nix"
                  exit 1
                fi
                # Insert our custom DB behind it.
                sed '2ifile-db:${customDconfDb}' ${gdm}/share/dconf/profile/gdm > $out
              '';
            }
          );
    };
}
