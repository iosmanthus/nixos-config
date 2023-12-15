{ ... }: {
  imports = [
    ./sing-box.nix
    ./caddy.nix
    ./subgen.nix
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
  };
}
