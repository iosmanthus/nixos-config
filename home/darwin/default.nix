{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./vscode
  ];

  home.stateVersion = "24.11";

  sops.age.keyFile = "${config.admin.home}/.config/sops/age/keys.txt";

  home.packages = with pkgs; [
    git
    tree
  ];
}
