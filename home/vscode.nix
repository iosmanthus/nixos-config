{ pkgs
, ...
}:
{
  home.packages = with pkgs;[ nixpkgs-fmt rnix-lsp ];
  programs.vscode = {
    enable = true;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "better-comments";
        publisher = "aaron-bond";
        version = "2.1.0";
        sha256 = "0kmmk6bpsdrvbb7dqf0d3annpg41n9g6ljzc1dh0akjzpbchdcwp";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "11.6.0";
        sha256 = "0lhrw24ilncdczh90jnjx71ld3b626xpk8b9qmwgzzhby89qs417";
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
        version = "0.27.2";
        sha256 = "1ayyqm7bpz9axxp9avnr0y7kcqzpl1l538m7szdqgrra3956irna";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "1.6.1";
        sha256 = "1l6nrbqkq1p62dkmzs4sy0rxbid3qa1104s3fd9fzkmc1sldzgsn";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.16";
        sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
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
        version = "0.2.727";
        sha256 = "110328yvhic9l8as0s81k4jbjcd602vmbz0khrnfbj9rpl2m3sds";
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
        version = "2021.8.42660";
        sha256 = "11yffdjflpy3lv7h6b4f5bi6pk0s5dsffib7rwlv0v6d6pbpl0yl";
      }
      {
        name = "color-highlight";
        publisher = "naumovs";
        version = "2.4.0";
        sha256 = "118y2wzmxxm9y4n96gld4nqlm5dglac3vp4fm96mipdjj2ll6n7s";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.10.0";
        sha256 = "119zpdx2hx9d1xb3d9d773b88i2awr62ivmmnhxm9zp77x9y6b70";
      }
      {
        name = "vscode-commons";
        publisher = "redhat";
        version = "0.0.6";
        sha256 = "1b8nlhbrsg3kj27f1kgj8n5ak438lcfq5v5zlgf1hzisnhmcda5n";
      }
      {
        name = "vscode-yaml";
        publisher = "redhat";
        version = "0.22.0";
        sha256 = "1ffsah3pwxfa8ya2c0a3q1wh5ngh621zgidfwl8iggnrl7nbwl3k";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.4.26";
        sha256 = "04ll5zbndc0pknpdp2p5v9l4ifiq1v43n7azv5j7y4gwfp9mqirq";
      }
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.14.2";
        sha256 = "17djwa2bnjfga21nvyz8wwmgnjllr4a7nvrsqvzm02hzlpwaskcl";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.21.7";
        sha256 = "160h8svp78snwq7bl6acbkmsb2664fiznnjqim9lh2bnyrlh69ww";
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
          "security.workspace.trust.enabled" = false;

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

          "editor.fontFamily" = "Hasklig, 'Material-Design-Iconic-Font', feather";
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
