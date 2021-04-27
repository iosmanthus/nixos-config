{ config, pkgs, ... }:
{
  home.packages = with pkgs;
    [
      bat
      exa
      neovim
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

      dig = "dig +ttlunits";

      nat = "sudo iptables -t nat -nvL";
      mangle = "sudo iptables -t mangle -nvL";
      filter = "sudo iptables -nvL";
    };
  };
}
