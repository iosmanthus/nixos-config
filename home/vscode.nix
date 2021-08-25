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
        version = "0.27.1";
        sha256 = "1985bbmnqqlss8h2ma0qgzj2g9xp4za58y2dyiwkh64bzpd6814x";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "1.6.0";
        sha256 = "01f87wn7lnrh9cyk6yxdv91bn9z6a9c6h62vxznqd6ff5ryv2fiw";
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
        version = "0.2.710";
        sha256 = "091wkpq65nqc86fnbwy9glpskvhl4w07k7zjy0jhry78qjlaizb3";
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
        version = "2021.8.18181";
        sha256 = "1433n5a2j1mqbh26in7f3j08skygj2n1nm4qwyf4fc4lr02ldi8c";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.9.0";
        sha256 = "133mmcvbmks3xp2wlay00gzbnqmjm019ziksaz4xadc7r19cy0fv";
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
        version = "3.4.22";
        sha256 = "11m50d3zsk8ihwfir177v484s466p8nyyl6q9zhzzhagb9xw0b51";
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
        version = "1.21.6";
        sha256 = "1hk6aqa3mxh0n2ka78p6ral5s0y2pcmnrnfhz4vhxdvgjx0zypn3";
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
