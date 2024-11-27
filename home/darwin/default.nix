{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../base/kitty
    ../base/tmux

    ./vscode
    ./shell
    ./firefox
  ];

  home.stateVersion = "24.11";

  sops.age.keyFile = "${config.admin.home}/.config/sops/age/keys.txt";

  home.packages = with pkgs; [
    fd
    btop
    gh
    git
    htop
    k9s
    kubectl
    kubectx
    mycli
    neofetch
    tree
  ];
}
