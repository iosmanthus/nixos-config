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
        version = "11.6.1";
        sha256 = "0nghanaxa5db7lxfi4nly45iaps560zkwsfhmzhiiaan0hj0qmcs";
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
        version = "7.1.1";
        sha256 = "1b9q7919gaycg465d3k3pi8n54ljvam3qr6r2ys399x3ppyv17sn";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.29.0";
        sha256 = "1ky5xnl300m42ja8sh3b4ynn8k1nnrcbxxhn3c3g5bsyzsrr1nmz";
      }
      {
        name = "haskell";
        publisher = "haskell";
        version = "1.7.1";
        sha256 = "11myrk3hcc2hdw2n07w092s78aa6igpm7rgvn7ac9rbkkvc66rsi";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.18";
        sha256 = "1v3j67j8bydyqba20b2wzsfximjnbhknk260zkc0fid1xzzb2sbn";
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
        version = "0.2.792";
        sha256 = "1m4g6nf5yhfjrjja0x8pfp79v04lxp5lfm6z91y0iilmqbb9kx1q";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.17.0";
        sha256 = "01na7j64mavn2zqfxkly9n6fpr6bs3vyiipy09jkmr5m86fq0cdx";
      }
      {
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.65.8";
        sha256 = "07w085crhvp8wh3n1gyfhfailfq940rffpahsp5pv8j200v2s0js";
      }
      {
        name = "remote-ssh-nightly";
        publisher = "ms-vscode-remote";
        version = "2021.10.36984";
        sha256 = "1ck6whn231z6lwg9li1494vsia7nciggg57xzs47awzzlj1ad0k5";
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
        version = "1.1.0";
        sha256 = "1cc871wdbasfkf37vkkanqf9jfzzvmvzi7gxyl63w613hb9g75w2";
      }
      {
        name = "tabnine-vscode";
        publisher = "TabNine";
        version = "3.4.33";
        sha256 = "1labprw5hjar0mnjarqzfanzc16p4dx9qjf1wygzrf4dwj4isixh";
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
        version = "1.21.10";
        sha256 = "0c9m7mc2kmfzj3hkwq3d4hj43qha8a75q5r1rdf1xfx8wi5hhb1n";
      }
      {
        name = "markdown-all-in-one";
        publisher = "yzhang";
        version = "3.4.0";
        sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
      }
      {
        name = "copilot";
        publisher = "GitHub";
        version = "1.6.3503";
        sha256 = "0yv82a5gn8w3hj4djn52001wbdhxwwaxc7r7mw702yqf4qaa2q8m";
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
        "editor.lineHeight" = 28;
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
