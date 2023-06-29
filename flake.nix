{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    master.url = "github:NixOS/nixpkgs/master";

    stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    sops-nix.url = "github:Mic92/sops-nix/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    vscode-insiders = {
      url = "github:iosmanthus/code-insiders-flake";
      inputs.nixpkgs.follows = "master";
    };

    jetbrains.url = "github:NixOS/nixpkgs/master";

    nur.url = "github:nix-community/NUR/master";

    zoom.url = "github:NixOS/nixpkgs?ref=pull/240462/head";
  };
  outputs =
    { nixpkgs
    , flake-utils
    , home-manager
    , sops-nix
    , nur
    , vscode-insiders
    , ...
    }@inputs:
    let
      inherit (import ./lib) mkOverlay;

      mkBranch = system: branch: config: import inputs.${branch} {
        inherit system config;
      };

      mkJetbrainsOverlay = system: _self: _super:
        mkOverlay
          {
            branch = mkBranch system "jetbrains" {
              allowUnfree = true;
            };
            packages = [
              "jetbrains"
            ];
          };

      mkMasterOverlay = system: _self: _super:
        mkOverlay {
          branch = mkBranch system "master" {
            allowUnfree = true;
          };
          packages = [
            "bat"
            "discord"
            "docker"
            "exa"
            "fd"
            "firefox"
            "feishu"
            "firmwareLinuxNonfree"
            "gh"
            "google-chrome"
            "i3"
            "kitty"
            "lens"
            "logseq"
            "neovim"
            "notion-app-enhanced"
            "oh-my-zsh"
            "ripgrep"
            "rnix-lsp"
            "rofi"
            "rust-analyzer"
            "sops"
            "starship"
            "tmux"
            "vscode-extensions"
            "vscode"
            "zoxide"
            "zsh"
            "nixUnstable"
            "thunderbird"
          ];
        };

      mkStableOverlay = system: _self: _super:
        mkOverlay {
          branch = mkBranch system "stable" { };
          packages = [ ];
        };

      mkZoomOverlay = system: _self: _super:
        mkOverlay {
          branch = mkBranch system "zoom" {
            allowUnfree = true;
          };
          packages = [
            "zoom-us"
          ];
        };

      mkCommonModules =
        system: [
          ./system/configuration.nix
          ./modules/gtk-theme
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          ({ config, ... }: {
            home-manager = {
              sharedModules = [
                ./modules/gtk-theme
                ./modules/immutable-file.nix
                ./modules/mutable-vscode-ext.nix
                (./. + "/machines/${config.machine.userName}.nix")
              ];
              users.${config.machine.userName} = import ./home;
              useGlobalPkgs = true;
              verbose = true;
            };
          })
          {
            nixpkgs.overlays =
              map (mkBuilder: mkBuilder system) [
                mkMasterOverlay
                mkStableOverlay
                mkJetbrainsOverlay
                mkZoomOverlay
              ] ++ [
                (import ./overlays.nix)
                nur.overlay
                vscode-insiders.overlays.default
              ];
          }
        ];
    in
    {
      nixosConfigurations =
        {
          # For more information of this field, check:
          # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/eval-config.nix
          iosmanthus-legion = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              { networking.hostName = "iosmanthus-legion"; }
              ./machines/iosmanthus-legion
              ./secrets/iosmanthus
              ./secrets/proxy
            ] ++ (mkCommonModules system);
          };
          iosmanthus-xps = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              { networking.hostName = "iosmanthus-xps"; }
              ./machines/iosmanthus-xps
              ./secrets/iosmanthus
              ./secrets/proxy
            ] ++ (mkCommonModules system);
          };
        };
    } // flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            fd
            gnumake
            nix-output-monitor
            nixpkgs-fmt
            sops
            yapf
            statix
          ];
        };
      });
}
