{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    master.url = "github:NixOS/nixpkgs/master";

    stable.url = "github:NixOS/nixpkgs/nixos-22.05";

    sops-nix.url = "github:Mic92/sops-nix/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils/master";

    nixos-vscode-server = {
      url = "github:iosmanthus/nixos-vscode-server/add-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    feishu.url = "github:iosmanthus/feishu-flake/main";

    nur.url = github:nix-community/NUR;
  };
  outputs =
    { nixpkgs
    , flake-utils
    , home-manager
    , sops-nix
    , nur
    , feishu
    , ...
    }@inputs:
    let
      inherit (import ./lib) mkOverlay;

      mkBranch = system: branch: import inputs.${branch} {
        inherit system;
        config.allowUnfree = true;
      };

      mkStableOverlay = (system: _self: _super:
        mkOverlay {
          branch = mkBranch system "stable";
          packages = [
            "sioyek"
          ];
        });

      mkMasterOverlay = (system: _self: _super:
        mkOverlay {
          branch = mkBranch system "master";
          packages = [
            "bat"
            "discord"
            "exa"
            "fd"
            "firefox"
            "gh"
            "google-chrome"
            "i3"
            "jetbrains"
            "kitty"
            "neovim"
            "notion-app-enhanced"
            "oh-my-zsh"
            "polybar"
            "ripgrep"
            "rnix-lsp"
            "rofi"
            "rust-analyzer"
            "sops"
            "starship"
            "tmux"
            "vscode-extensions"
            "vscode"
            "zoom-us"
            "zoxide"
            "zsh"
            "firmwareLinuxNonfree"
          ];
        });

      mkCommonModules =
        system: [
          ./system/configuration.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          ({ pkgs, ... }: {
            imports = [ inputs.nixos-vscode-server.nixosModules.system ];
            services.auto-fix-vscode-server = {
              enable = true;
              nodePackage = pkgs.nodejs-16_x;
            };
          })
          ({ config, ... }: {
            home-manager = {
              sharedModules = [
                ./modules/immutable-file.nix
                ./modules/mutable-vscode-ext.nix
                (builtins.toPath ./.
                  + "/machines/${config.machine.userName}.nix")
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
              ] ++ [
                (import ./overlays.nix)
                nur.overlay
                feishu.overlay
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
          buildInputs = with pkgs; [ gnumake nix-output-monitor nixpkgs-fmt fd sops yapf nix-linter ];
        };
      });
}
