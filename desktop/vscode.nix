{ pkgs, ... }:

{

  # TODO: use nix to manage vscode's extensions
  environment.systemPackages = with pkgs;[
    vscode
    # NixOS host remote ssh dependency
    # https://github.com/microsoft/vscode-remote-release/issues/648#issuecomment-503148523
    nodejs-12_x

    rnix-lsp
  ];

}
