{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../base/kitty
    ../base/tmux
    ../base/git

    ./vscode
    ./shell
    ./firefox
    ./gpg
  ];

  home.stateVersion = "24.11";

  sops.age.keyFile = "${config.admin.home}/.config/sops/age/keys.txt";

  home.packages = with pkgs; [
    ascii
    awscli2
    btop
    dockutil
    fd
    fzf
    gh
    git
    htop
    httpie
    k9s
    kubectl
    kubectx
    mycli
    neofetch
    ripgrep
    sops
    tldr
    tokei
    tree
  ];

  programs.neovim.enable = true;

  programs.go.enable = true;
}
