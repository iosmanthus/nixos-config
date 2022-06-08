{ pkgs, ... }:
let
  fcitx = "${pkgs.fcitx5}/bin/fcitx5-remote";
in
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    rnix-lsp
  ];
  programs.vscode = {
    enable = true;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (
        (import ./extensions.nix).extensions
      )
    ++ (with pkgs.vscode-extensions; [
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
    userSettings = {
      "extensions.autoUpdate" = false;
      "security.workspace.trust.enabled" = false;
      "rust-analyzer.serverPath" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      "python.formatting.yapfPath" = "${pkgs.yapf}/bin/yapf";
      "python.formatting.provider" = "yapf";

      "keyboard.dispatch" = "keyCode";
      "vim.autoSwitchInputMethod.defaultIM" = "1";
      "vim.autoSwitchInputMethod.enable" = true;
      "vim.autoSwitchInputMethod.obtainIMCmd" = "${fcitx}";
      "vim.autoSwitchInputMethod.switchIMCmd" = "${fcitx} -t {im}";
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
      "editor.fontSize" = 11;
      # "editor.fontWeight": "650",
      "editor.lineHeight" = 25;
      "editor.lineNumbers" = "relative";
      "editor.inlineSuggest.enabled" = true;

      "terminal.integrated.commandsToSkipShell" = [ "-workbench.action.quickOpen" ];
      "terminal.integrated.fontFamily" = "'Meslo LG L', 'Hasklug Nerd Font'";
      "terminal.integrated.fontWeight" = "normal";
      "terminal.integrated.fontSize" = 11;
      "terminal.integrated.fontWeightBold" = "600";

      "window.menuBarVisibility" = "toggle";
      "window.newWindowDimensions" = "inherit";
      "window.zoomLevel" = 1.2;

      "workbench.colorTheme" = "Community Material Theme Darker High Contrast";
      "workbench.iconTheme" = "material-icon-theme";

      "nix.enableLanguageServer" = true;
    };
  };
}
