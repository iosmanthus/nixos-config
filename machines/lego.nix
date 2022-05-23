{ ... }: {
  imports = [
    ./common
  ];
  machine = {
    userName = "lego";
    userEmail = "mugglelego@gmail.com";
    hashedPassword = "$6$CqpPWmrjisMp7bWp$1NT7c5D60XJ5lb/pLP9jA9eNFWsIKfbsLu6fDzeWSTQYjGbKlN3EuIE0wgAHB6C/8rR4HVZeX4XbZ/rnQJVUY0";
    shell = pkgs.zsh;
  };
}
