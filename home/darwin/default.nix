{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../base/tmux
    ../base/git

    ./firefox
    ./gpg
    ./kitty
    ./shell
    ./vscode
    ./maccy
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
