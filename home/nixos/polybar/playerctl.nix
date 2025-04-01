{ pkgs, ... }:
let
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  colrm = "${pkgs.util-linux}/bin/colrm";
  cut = "${pkgs.coreutils}/bin/cut";
  limit = 32;
  firstPlayer = pkgs.writeShellScript "first-player" ''
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
  script = pkgs.writeShellScript "playerctl" ''
    player=$(${firstPlayer} | ${cut} -d '.' -f1)
    player_status=$(${playerctl} -p $player status)

    if [ "$player_status" = "Playing" ]; then
        echo "$player: ▶️ $(${playerctl} metadata title | ${colrm} ${builtins.toString limit})"
    elif [ "$player_status" = "Paused" ]; then
        echo "$player: ⏸️ $(${playerctl} metadata title | ${colrm} ${builtins.toString limit})"
    else
        echo ": No Track"
    fi
  '';
in
''
  [module/playerctl]
  type = custom/script
  exec = ${script}
  interval = 0.1
  click-left = ${playerctl} -p $(${firstPlayer}) previous &
  click-right = ${playerctl} -p $(${firstPlayer}) next &
  click-middle = ${playerctl} -p $(${firstPlayer}) play-pause &
  scroll-up = ${playerctld} unshift
  scroll-down = ${playerctld} shift
''
