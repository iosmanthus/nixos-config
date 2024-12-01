{ pkgs, ... }:
let
  ignoreOutput = pkgs.writers.writePython3 "ignore_output" { libraries = [ ]; } ''
    import subprocess
    import sys

    subprocess.Popen(
      sys.argv[1:],
      stdout=subprocess.DEVNULL,
      stderr=subprocess.DEVNULL
    )
  '';
in
{
  imports = [
    ../../base/shell
  ];

  home.packages = with pkgs; [
    systemd
    sudo
    iptables
  ];

  programs.zsh = {
    shellAliases = {
      reboot = "sudo systemctl reboot -i";
      poweroff = "sudo systemctl poweroff -i";

      i3-logout = "i3-msg exit";

      connect-xm3 = "repeat 5 { bluetoothctl connect 38:18:4C:F9:98:A9; sleep 2 } 2>&1 > /dev/null &disown";
      connect-xm4 = "repeat 5 { bluetoothctl connect AC:80:0A:0D:E9:47; sleep 2 } 2>&1 > /dev/null &disown";
      connect-xm5 = "repeat 5 { bluetoothctl connect 80:99:E7:5B:45:46; sleep 2 } 2>&1 > /dev/null &disown";
      connect-jbl = "repeat 5 { bluetoothctl connect 70:99:1C:7F:E3:EF; sleep 2 } 2>&1 > /dev/null &disown";
      disconnect-xm3 = "bluetoothctl disconnect 38:18:4C:F9:98:A9";
      disconnect-xm4 = "bluetoothctl disconnect AC:80:0A:0D:E9:47";
      disconnect-xm5 = "bluetoothctl disconnect 80:99:E7:5B:45:46";
      disconnect-jbl = "bluetoothctl disconnect 70:99:1C:7F:E3:EF";

      jctl = "journalctl";
      juctl = "journalctl --user";

      nat = "sudo iptables -t nat -nvL";
      mangle = "sudo iptables -t mangle -nvL";
      filter = "sudo iptables -nvL";

      clion = "${ignoreOutput} clion nosplash";
      goland = "${ignoreOutput} goland nosplash";
      idea-ultimate = "${ignoreOutput} idea-ultimate nosplash";
      rr = "${ignoreOutput} rust-rover nosplash";
      webstorm = "${ignoreOutput} webstorm nosplash";
    };
  };
}
