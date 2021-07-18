{ pkgs
, ...
}:
{
  home.packages = with pkgs;[ nixpkgs-fmt rnix-lsp ];
  programs.vscode = {
    enable = true;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-yaml";
        publisher = "redhat";
        version = "0.20.0";
        sha256 = "8cc0ba14055762f35a355afd123a820af620dce8b110c6c08e84b90656c8bf91";
      }
      {
        name = "better-comments";
        publisher = "aaron-bond";
        version = "2.1.0";
        sha256 = "0kmmk6bpsdrvbb7dqf0d3annpg41n9g6ljzc1dh0akjzpbchdcwp";
      }
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.7";
        sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.5.1";
        sha256 = "0wy23fnd21jfqw88cyspzf09yvz2bpnlxniz4bc61n4pqm7xxki1";
      }
      {
        name = "vsc-community-material-theme";
        publisher = "Equinusocio";
        version = "1.4.4";
        sha256 = "005l4pr9x3v6x8450jn0dh7klv0pv7gv7si955r7b4kh19r4hz9y";
      }
      {
        name = "shell-format";
        publisher = "foxundermoon";
        version = "7.1.0";
        sha256 = "09z72mdr5bfdcb67xyzlv7lb9vyjlc3k9ackj4jgixfk40c68cnj";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.26.0";
        sha256 = "1lhpzz68vsxkxwp12rgwiqwm1rmlwn6anmz6z4alr100hxxx31h7";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "1.4.0";
        sha256 = "1jk702fd0b0aqfryixpiy6sc8njzd1brd0lbkdhcifp0qlbdwki0";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.12";
        sha256 = "1wkc5mvxv7snrpd0py6x83aci05b9fb9v4w9pl9d1hyaszqbfnif";
      }
      {
        name = "language-haskell";
        publisher = "justusadam";
        version = "3.4.0";
        sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
      }
      {
        name = "rust-analyzer";
        publisher = "matklad";
        version = "0.2.637";
        sha256 = "1bi9xklbls0jpccfg9bh3vk5s7v8f3a6f331b4hw0mpiv72ls5fr";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.65.7";
        sha256 = "1q5x6ds2wlg3q98ybvic00j19l33pablx7wczywa7fc26f8h9xzj";
      }
      {
        name = "remote-ssh-nightly";
        publisher = "ms-vscode-remote";
        version = "2021.5.29700";
        sha256 = "17rcp7064qv0cf27f213qzp4sjzqycxrkp4i48mgkad8v6h6sy8z";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.7.0";
        sha256 = "0n8xv62l9z31gndv1lhwrsm9qjp5vliqwgn9vsp86xd0hs5ycm2w";
      }
      {
        name = "vscode-commons";
        publisher = "redhat";
        version = "0.0.6";
        sha256 = "1b8nlhbrsg3kj27f1kgj8n5ak438lcfq5v5zlgf1hzisnhmcda5n";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.4.6";
        sha256 = "1k1vvyg65j0ccl4zl04ip43w71zaq4b03dsiwfsjyxfj7f263am7";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.21.3";
        sha256 = "1rpm5cas5q4v7w9i0b6avnprlk3h5yfpigzd3kvrznmxinvd2rrp";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.4.0";
        sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
      }
    ];

    keybindings = [
      {
        command = "selectNextSuggestion";
        key = "tab";
        when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "selectPrevSuggestion";
        key = "shift+tab";
        when = "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "-rust-analyzer.onEnter";
        key = "enter";
        when = "editorTextFocus && !suggestWidgetVisible && editorLangId == 'rust'";
      }
    ];
    userSettings =
      let
        fcitx5-remote = "${pkgs.fcitx5}/bin/fcitx5-remote";
      in
        {
          "extensions.autoUpdate" = false;

          "keyboard.dispatch" = "keyCode";
          "vim.autoSwitchInputMethod.defaultIM" = "1";
          "vim.autoSwitchInputMethod.enable" = true;
          "vim.autoSwitchInputMethod.obtainIMCmd" = "${fcitx5-remote}";
          "vim.autoSwitchInputMethod.switchIMCmd" = "${fcitx5-remote} -t {im}";
          "vim.camelCaseMotion.enable" = true;
          "vim.debug.silent" = true;
          "vim.easymotion" = true;
          "vim.enableNeovim" = true;
          "vim.easymotionMarkerFontFamily" = "monospace";
          "vim.handleKeys" = {
            "<C-a>" = false;
            "<C-c>" = false;
            "<C-d>" = false;
            "<C-f>" = false;
            "<C-j>" = false;
            "<C-k>" = false;
          };
          "vim.highlightedyank.enable" = true;
          "vim.hlsearch" = true;
          "vim.leader" = "<space>";
          "vim.normalModeKeyBindingsNonRecursive" = [
            {
              before = [ "<C-n>" ];
              commands = [ ":nohl" ];
            }
            {
              before = [ ";" ];
              commands = [ "vim.showQuickpickCmdLine" ];
            }
          ];
          "vim.visualstar" = true;

          "editor.fontFamily" = "monospace";
          "editor.fontLigatures" = true;
          "editor.fontSize" = 16;
          # "editor.fontWeight": "650",
          "editor.lineHeight" = 25;
          "editor.lineNumbers" = "relative";

          "terminal.integrated.commandsToSkipShell" = [ "-workbench.action.quickOpen" ];
          "terminal.integrated.fontFamily" = "monospace";
          "terminal.integrated.fontWeight" = "normal";
          "terminal.integrated.fontWeightBold" = "600";

          "window.menuBarVisibility" = "toggle";
          "window.newWindowDimensions" = "inherit";

          "workbench.colorTheme" = "Community Material Theme Darker High Contrast";
          "workbench.iconTheme" = "material-icon-theme";

          "nix.enableLanguageServer" = true;
          "tabnine.experimentalAutoImports" = true;
        };
  };
}
