{ pkgs, ... }: {
  home.packages = with pkgs; [
    nixpkgs-fmt
    rnix-lsp
  ];
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
        version = "12.0.2";
        sha256 = "16l2wy6zyh11mq7d1r1qg668d5c637yd3arzqlqhjf91drmaxpbs";
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
        version = "7.2.2";
        sha256 = "00wc0y2wpdjs2pbxm6wj9ghhfsvxyzhw1vjvrnn1jfyl4wh3krvi";
      }
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.7.5250";
        sha256 = "1dc9dkc60v4pbn6s223i7m1lr14pjkjg1m9rfny90rjf248838d1";
      }
      {
        name = "github-vscode-theme";
        publisher = "GitHub";
        version = "6.0.0";
        sha256 = "1vakkwnw43my74j7yjp30kfmmbc37jmr3qia5lvg8sbws3fq40jj";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.32.0";
        sha256 = "0a3pmpmmr8gd0p8zw984a73cp2yyi4lvz0s03msvkrxmn5k9xhis";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "1.8.0";
        sha256 = "0yzcibigxlvh6ilba1jpri2irsjnvyy74vzn3rydcywfc17ifkzs";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.20";
        sha256 = "16mmivdssjky11gmih7zp99d41m09r0ii43n17d4i6xwivagi9a3";
      }
      {
        name = "language-haskell";
        publisher = "justusadam";
        version = "3.4.0";
        sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.20.0";
        sha256 = "0a1v8hqbrl51pxbzvjd69azqcyqid4gmva3dnk440q7szr61hy4b";
      }
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.77.2022030315";
        sha256 = "1wyz3lnz821znsbdwjigndy3pq43f31v0jg8hfnhgmj05a4y8kjn";
      }
      {
        name = "color-highlight";
        publisher = "naumovs";
        version = "2.5.0";
        sha256 = "0ri1rylg0r9r1kdc67815gjlq5fwnb26xpyziva6a40brrbh70vm";
      }
      {
        name = "material-icon-theme";
        publisher = "PKief";
        version = "4.14.1";
        sha256 = "1d6wv5jxg4syz9dlj3q4rrv1cfk86hlff5132qga7j6y8z8f4x9q";
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
        version = "1.5.1";
        sha256 = "1qsjsfggfya282rh618fc89cfgpxii7yv2kyh5is6x2r2606cy15";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.5.26";
        sha256 = "0brlklxmfinvmxivci7s36a72jpxdxcka93vizps6hpx33h4wwr0";
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
        version = "1.22.2";
        sha256 = "1d85dwlnfgn7d32ivza0bv1zf9bh36fx7gbi586dligkw202blkn";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.4.0";
        sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
      }
      {
        name = "vscode-proto3";
        publisher = "zxh404";
        version = "0.5.5";
        sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
      }
      {
        name = "markdown-preview-github-styles";
        publisher = "bierner";
        version = "1.0.1";
        sha256 = "1bjx46v17d18c9bplz70dx6fpsc6pr371ihpawhlr1y61b59n5aj";
      }
      {
        name = "vscode-theme-onedark";
        publisher = "akamud";
        version = "2.2.3";
        sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.232.4";
        sha256 = "0cznn5pba51p3nhjf2qn3lp6l9gvjp1qmp4zdbmpcfy5zpw8gmpr";
      }
      {
        name = "path-intellisense";
        publisher = "christian-kohler";
        version = "2.8.0";
        sha256 = "04vardis9k6yzaha5hhhv16c3z6np48adih46xj88y83ipvg5z2l";
      }
    ] ++ (with pkgs.vscode-extensions; [
      matklad.rust-analyzer
    ]);

    keybindings = [
      {
        command = "selectNextSuggestion";
        key = "tab";
        when =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "selectPrevSuggestion";
        key = "shift+tab";
        when =
          "editorTextFocus && suggestWidgetMultipleSuggestions && suggestWidgetVisible";
      }
      {
        command = "-rust-analyzer.onEnter";
        key = "enter";
        when =
          "editorTextFocus && !suggestWidgetVisible && editorLangId == 'rust'";
      }
    ];
    userSettings =
      let fcitx5-remote = "${pkgs.fcitx5}/bin/fcitx5-remote";
      in
      {
        "extensions.autoUpdate" = false;
        "security.workspace.trust.enabled" = false;
        "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}/bin/rust-analyzer";

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

        "editor.fontFamily" = "'Meslo LG L', 'Material-Design-Iconic-Font', feather";
        "editor.fontLigatures" = false;
        "editor.fontSize" = 13;
        # "editor.fontWeight": "650",
        "editor.lineHeight" = 25;
        "editor.lineNumbers" = "relative";
        "editor.inlineSuggest.enabled" = true;

        "terminal.integrated.commandsToSkipShell" =
          [ "-workbench.action.quickOpen" ];
        "terminal.integrated.fontFamily" = "'Meslo LG L', 'Hasklug Nerd Font'";
        "terminal.integrated.fontWeight" = "normal";
        "terminal.integrated.fontWeightBold" = "600";

        "window.menuBarVisibility" = "toggle";
        "window.newWindowDimensions" = "inherit";

        "workbench.colorTheme" = "Atom One Dark";
        "workbench.iconTheme" = "material-icon-theme";

        "nix.enableLanguageServer" = true;
        "tabnine.experimentalAutoImports" = true;
      };
  };
}
