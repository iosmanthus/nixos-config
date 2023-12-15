{
  description = "God does not play dice";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    master.url = "github:NixOS/nixpkgs";

    sops-nix.url = "github:iosmanthus/sops-nix/nested-secrets";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    berberman = {
      url = "github:berberman/flakes/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jetbrains.url = "github:NixOS/nixpkgs/master";
  };
  outputs =
    { self
    , nixpkgs
    , master
    , flake-utils
    , home-manager
    , sops-nix
    , berberman
    , ...
    }:
    let
      this = import ./packages;

      mkWorkstationModules =
        system: [
          ./nixos/workstation
          ./secrets/proxy

          self.nixosModules.system
          self.nixosModules.admin.iosmanthus

          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          ({ config, ... }: {
            home-manager = {
              users.${config.admin.name} = { ... }: {
                imports = [
                  (./secrets + "/${config.admin.name}")
                  ./nixos/workstation/home
                ];
              };
              sharedModules = [
                sops-nix.homeManagerModule
                self.nixosModules.home-manager
                self.nixosModules.admin.iosmanthus
              ];
              useGlobalPkgs = true;
              verbose = true;
            };
          })
          {
            nixpkgs.overlays =
              [
                self.overlays.unstable
                self.overlays.jetbrains
                self.overlays.default

                berberman.overlays.default
              ];
          }
        ];
    in
    {
      packages.x86_64-linux = this.packages (import nixpkgs {
        allowUnfree = true;
        system = "x86_64-linux";
      });
      overlays = {
        default = this.overlay;
        unstable = this.branchOverlay {
          branch = master;
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            # https://github.com/NixOS/nixpkgs/issues/265125
            permittedInsecurePackages = [
              "electron-25.9.0"
            ];
          };
          packages = [
            "bat"
            "discord"
            "docker"
            "eza"
            "fd"
            "feishu"
            "firefox"
            "firmwareLinuxNonfree"
            "gh"
            "google-chrome"
            "i3"
            "kitty"
            "lens"
            "logseq"
            "neovim"
            "nixos-artwork"
            "nixUnstable"
            "notion-app-enhanced"
            "oh-my-zsh"
            "ripgrep"
            "rnix-lsp"
            "rofi"
            "rust-analyzer"
            "sops"
            "starship"
            "tmux"
            "virt-manager"
            "virt-viewer"
            "vscode-extensions"
            "vscode"
            "zoxide"
            "zsh"
          ];
        };
        jetbrains = this.branchOverlay {
          branch = master;
          system = "x86_64-linux";
          config = { allowUnfree = true; };
          packages = [ "jetbrains" ];
        };
      };
      nixosModules = import ./modules;
      nixosConfigurations = {
        iosmanthus-xps = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./nixos/iosmanthus-xps
          ] ++ (mkWorkstationModules system);
        };
        iosmanthus-legion = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [
            ./nixos/iosmanthus-legion
          ] ++ (mkWorkstationModules system);
        };
        aws-lightsail-0 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./secrets/aws-lightsail-0
            ./nixos/aws-lightsail-0

            sops-nix.nixosModules.sops
            self.nixosModules.lightsail
            {
              nixpkgs.overlays = [
                self.overlays.default
              ];
            }
          ];
        };
      };
    } // flake-utils.lib.eachSystem
      [ "x86_64-linux" ]
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            fd
            gnumake
            nix-output-monitor
            nixpkgs-fmt
            sops
            statix
            terraform
            yapf
          ];
        };
      });
}
