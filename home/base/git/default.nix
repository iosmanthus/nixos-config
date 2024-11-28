{
  pkgs,
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = config.admin.name;
    userEmail = config.admin.email;
    extraConfig = {
      core = {
        editor = "${pkgs.vscode-launcher} --wait";
        fsmonitor = true;
      };
      pull = {
        rebase = false;
      };
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
    signing = {
      key = config.admin.gpgPubKey;
      signByDefault = true;
    };
    ignores = [
      "/bazel-*"
      "/.idea"
    ];
  };
}
