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
        version = "3.0.0";
        sha256 = "17b7m50z0fbifs8azgn6ygcmgwclssilw9j8nb178szd6zrjz2vf";
      }
      {
        name = "vscode-theme-onedark";
        publisher = "akamud";
        version = "2.2.3";
        sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
      }
      {
        name = "markdown-preview-github-styles";
        publisher = "bierner";
        version = "1.0.1";
        sha256 = "1bjx46v17d18c9bplz70dx6fpsc6pr371ihpawhlr1y61b59n5aj";
      }
      {
        name = "path-intellisense";
        publisher = "christian-kohler";
        version = "2.8.0";
        sha256 = "04vardis9k6yzaha5hhhv16c3z6np48adih46xj88y83ipvg5z2l";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "12.0.6";
        sha256 = "1d7gzxsyxrhvvx2md6gbcwiawd8f3jarxfbv2qhj7xl1phd7zja3";
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
        version = "1.19.5865";
        sha256 = "1c892q2ivkn3cib4jc9fnka8r5ba6h9sl2b5d2n8jhxgrl5bfnri";
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
        version = "0.33.0";
        sha256 = "1wd9zg4jnn7y75pjqhrxm4g89i15gff69hsxy7y5i6njid0x3x0w";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "2.2.0";
        sha256 = "0qgp93m5d5kz7bxlnvlshcd8ms5ag48nk5hb37x02giqcavg4qv0";
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
        version = "3.6.0";
        sha256 = "115y86w6n2bi33g1xh6ipz92jz5797d3d00mr4k8dv5fz76d35dd";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.22.0";
        sha256 = "12qfwfqaa6nxm6gg2g7g4m001lh57bbhhbpyawxqk81qnjw3vipr";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.235.0";
        sha256 = "13g91fdq93wmp855jlf1hmlmaknyvnxmbrh39v8sg7wch3ypx7z4";
      }
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.80.0";
        sha256 = "1n2lgyw77wqck93grd53k331xmgwirrl2hsr5mvlamshhmiwvi73";
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
        version = "4.17.0";
        sha256 = "1dmmqc003v45pmiz6yccpnvw94hbvbg7fhy24njii0kwpxbv4q7l";
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
        version = "1.7.0";
        sha256 = "1bbjpaypp0mq5akww5f0pkpq01j0xhhvkfr44f4lb2rdhr5nmnvc";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.5.45";
        sha256 = "0biyc7wc9nnnr3jax7d2vjnr7yp46hlyy5fm7kqdlgm6hqn4361b";
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
        version = "3.4.3";
        sha256 = "0z0sdb5vmx1waln5k9fk6s6lj1pzpcm3hwm4xc47jz62iq8930m3";
      }
      {
        name = "vscode-proto3";
        publisher = "zxh404";
        version = "0.5.5";
        sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
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

        "workbench.colorTheme" = "Community Material Theme Darker High Contrast";
        "workbench.iconTheme" = "material-icon-theme";

        "nix.enableLanguageServer" = true;
        "tabnine.experimentalAutoImports" = true;
      };
  };
}
