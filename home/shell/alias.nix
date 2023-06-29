{ pkgs
, ...
}:
let
  ignoreOutput = pkgs.writers.writePython3 "ignore_output"
    {
      libraries = [ ];
    } ''
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
  home.packages = with pkgs; [
    bat
    exa
    systemd
    sudo
    bind
    iptables
  ];

  programs.zsh = {
    shellAliases = {
      ls = "exa --group-directories-first";
      la = "ls -a";
      ll = "ls -l";
      l = "ls -F";

      cat = "bat";

      vim = "nvim";
      vi = "vim";

      py = "python";
      py2 = "python2";

      reboot = "sudo systemctl reboot -i";
      poweroff = "sudo systemctl poweroff -i";

      # TODO: refactor this shit.
      connect-xm3 = "repeat 5 { bluetoothctl connect 38:18:4C:F9:98:A9; sleep 2 } 2>&1 > /dev/null &disown";
      connect-xm4 = "repeat 5 { bluetoothctl connect AC:80:0A:0D:E9:47; sleep 2 } 2>&1 > /dev/null &disown";
      connect-jbl = "repeat 5 { bluetoothctl connect 70:99:1C:7F:E3:EF; sleep 2 } 2>&1 > /dev/null &disown";
      disconnect-xm3 = "bluetoothctl disconnect 38:18:4C:F9:98:A9";
      disconnect-xm4 = "bluetoothctl disconnect AC:80:0A:0D:E9:47";
      disconnect-jbl = "bluetoothctl disconnect 70:99:1C:7F:E3:EF";

      jctl = "journalctl";
      juctl = "journalctl --user";

      i3-logout = "i3-msg exit";

      dig = "dig +ttlunits";

      nat = "sudo iptables -t nat -nvL";
      mangle = "sudo iptables -t mangle -nvL";
      filter = "sudo iptables -nvL";

      clion = "${ignoreOutput} clion nosplash";
      goland = "${ignoreOutput} goland nosplash";
      idea-ultimate = "${ignoreOutput} idea-ultimate nosplash";

      k = "kubectl";
      kx = "kubectx";

      code = "${pkgs.runVscode}";
      n = "nix";
      nrs = "nixos-rebuild switch --use-remote-sudo";
    };
  };
}
