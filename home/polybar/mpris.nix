{ pkgs, ... }:
let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  colrm = "${pkgs.util-linux}/bin/colrm";
  limit = 30;
  playerMprisSimple = pkgs.writeShellScript "player-mpris-simple" ''
    player_status=$(${playerctl} status 2> /dev/null)

    if [ "$player_status" = "Playing" ]; then
        echo "▶️ $(${playerctl} metadata artist) - $(${playerctl} metadata title)" | ${colrm} ${
          builtins.toString limit
        }
    elif [ "$player_status" = "Paused" ]; then
        echo "⏸️ $(${playerctl} metadata artist) - $(${playerctl} metadata title)" | ${colrm} ${
          builtins.toString limit
        }
    else
        echo "No Track"
    fi

  '';
in
''
  [module/player-mpris-simple]
  type = custom/script
  exec = ${playerMprisSimple}
  interval = 1
  click-left = ${playerctl} previous &
  click-right = ${playerctl} next &
  click-middle = ${playerctl} play-pause &
''
