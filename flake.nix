{
  description = "God does not play dice";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    master.url = "github:NixOS/nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    berberman = {
      url = "github:berberman/flakes/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jetbrains.url = "github:NixOS/nixpkgs";

    base16.url = "github:SenchoPens/base16.nix";

    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

    code-insiders = {
      url = "github:iosmanthus/code-insider-flake";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , master
    , flake-utils
    , home-manager
    , sops-nix
    , berberman
    , base16
    , code-insiders
    , nixos-generators
    , ...
    }@inputs:
    let
      this = import ./packages;

      mkWorkstationModules =
        system: [
          ./nixos/workstation
          ./secrets/workstation

          self.nixosModules.workstation
          self.nixosModules.admin.iosmanthus

          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          base16.nixosModule

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
                base16.nixosModule
                self.nixosModules.home-manager
                self.nixosModules.admin.iosmanthus
              ];
              extraSpecialArgs = {
                inherit self;
              };
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
                code-insiders.overlays.default
              ];
          }
        ];
    in
    {
      packages.x86_64-linux = this.packages
        (import nixpkgs {
          config = {
            allowUnfree = true;
          };
          system = "x86_64-linux";
        }) // {
        nixos-gce-image = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "gce";
          specialArgs = {
            inherit self;
          };
          modules = [
            self.nixosModules.cloud.gce
          ];
        };
      };
      overlays = {
        default = this.overlay;
        unstable = this.branchOverlay {
          branch = master;
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          packages = [
            "bat"
            "brave"
            "discord"
            "docker"
            "eza"
            "fd"
            "feishu"
            "firmwareLinuxNonfree"
            "gh"
            "i3"
            "kitty"
            "lens"
            "neovim"
            "nixos-artwork"
            "nixUnstable"
            "oh-my-zsh"
            "ripgrep"
            "rofi"
            "rust-analyzer"
            "sops"
            "starship"
            "tmux"
            "virt-manager"
            "virt-viewer"
            "vscode"
            "zoxide"
            "zsh"
          ];
        };
        jetbrains = this.branchOverlay {
          branch = inputs.jetbrains;
          system = "x86_64-linux";
          config = { allowUnfree = true; };
          packages = [ "jetbrains" ];
        };
      };
      nixosModules = import ./modules;
      nixosConfigurations = {
        iosmanthus-xps = nixpkgs.lib.nixosSystem rec {
          specialArgs = { inherit self; };
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
          specialArgs = {
            inherit self;
          };
          modules = [
            ./secrets/endpoints
            ./secrets/aws-lightsail-0
            ./nixos/aws-lightsail-0

            sops-nix.nixosModules.sops

            self.nixosModules.atuin
            self.nixosModules.cloud.aws-lightsail
            self.nixosModules.cloud.sing-box
            self.nixosModules.o11y
            self.nixosModules.subgen

            home-manager.nixosModules.home-manager
            ({ config, ... }: {
              home-manager = {
                users.nixbuild = { ... }: {
                  imports = [
                    ./nixos/aws-lightsail-0/home
                  ];
                };
                useGlobalPkgs = true;
                verbose = true;
              };
            })

            {
              nixpkgs.overlays = [
                self.overlays.default
              ];
            }
          ];
        };

        gcp-instance-0 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
          };
          modules = [
            ./secrets/gcp-instance-0
            ./nixos/gcp-instance-0

            sops-nix.nixosModules.sops

            self.nixosModules.cloud.gce
            self.nixosModules.cloud.sing-box
            self.nixosModules.o11y

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
            go_1_20
            google-cloud-sdk
            gotools
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
