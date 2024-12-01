{
  pkgs,
  ...
}:
{
  imports = [
    ../../base/vscode
  ];

  programs.vscode = {
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        publisher = "ms-vscode-remote";
        name = "remote-ssh";
        version = "0.115.1";
        sha256 = "11gbam47rjga5ypqj0nm0g69x0v5pa175ap7yf3yj9l0a5y29b6h";
      }
    ];
  };
}
