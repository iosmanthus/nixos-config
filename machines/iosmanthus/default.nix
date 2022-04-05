{ config, pkgs, ... }: {
  imports = [
    ../common
  ];
  machine = {
    userName = "iosmanthus";
    userEmail = "myosmanthustree@gmail.com";
    hashedPassword = "$6$gR32JQgFbRXc8tU$McsRQyVYcImRhIajbCWxtte51jOZ8hf6h4Mk7WLap0.Bl9NNamdXUv9aRggBsibGGmp1SHVESVF1qLBl79l/c1";
    shell = pkgs.zsh;
  };
}
