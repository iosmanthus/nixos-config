{ pkgs, ... }:
let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  colrm = "${pkgs.util-linux}/bin/colrm";
  limit = 32;
  getFirstPlayer = pkgs.writeShellScript "get-first-player" ''
    players=$(${playerctl} --list-all)
    player=""
    for p in $players; do
        if [ "$(${playerctl} --player=$p status)" != "Stopped" ]; then
          player=$p
          break
        fi
    done
    echo $player
  '';
  playerMprisSimple = pkgs.writeShellScript "player-mpris-simple" ''
    player=$(${getFirstPlayer})
    player_status=$(${playerctl} -p $player status)

    if [ "$player_status" = "Playing" ]; then
        echo "▶️ $(${playerctl} metadata title)" | ${colrm} ${
          builtins.toString limit
        }
    elif [ "$player_status" = "Paused" ]; then
        echo "⏸️ $(${playerctl} metadata title)" | ${colrm} ${
          builtins.toString limit
        }
    else
        echo ": No Track"
    fi

  '';
in
''
  [module/player-mpris-simple]
  type = custom/script
  exec = ${playerMprisSimple}
  interval = 1
  click-left = ${playerctl} -p $(${getFirstPlayer}) previous &
  click-right = ${playerctl} -p $(${getFirstPlayer}) next &
  click-middle = ${playerctl} -p $(${getFirstPlayer}) play-pause &
''
