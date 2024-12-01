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

    nur.url = "github:nix-community/NUR";

    firefox.url = "github:nix-community/flake-firefox-nightly";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    vaultwarden.url = "github:iosmanthus/nixpkgs/bump-vaultwarden-20240912141923";

    nix-darwin = {
      url = "github:iosmanthus/nix-darwin/aerospace-path";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };
  outputs =
    {
      self,
      nixpkgs,
      master,
      flake-utils,
      home-manager,
      sops-nix,
      berberman,
      base16,
      code-insiders,
      nixos-generators,
      nur,
      nixos-hardware,
      nix-darwin,
      mac-app-util,
      ...
    }@inputs:
    let
      this = import ./packages;

      mkWorkstationModules = system: [
        ./nixos/workstation
        ./secrets/workstation

        self.nixosModules.workstation
        self.nixosModules.admin.iosmanthus

        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        base16.nixosModule

        (
          { config, ... }:
          {
            home-manager = {
              users.${config.admin.name} =
                { ... }:
                {
                  imports = [
                    (./secrets + "/${config.admin.name}")
                    ./home/nixos
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
          }
        )
        {
          nixpkgs.overlays = [
            self.overlays.unstable
            self.overlays.jetbrains
            self.overlays.default

            berberman.overlays.default
            code-insiders.overlays.default
            nur.overlay
          ];
        }
      ];
    in
    {
      packages.x86_64-linux =
        this.packages (
          import nixpkgs {
            config = {
              allowUnfree = true;
            };
            system = "x86_64-linux";
          }
        )
        // {
          nixos-gce-image = nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            format = "gce";
            specialArgs = {
              inherit self;
            };
            modules = [ self.nixosModules.cloud.gce ];
          };
        };
      overlays = {
        default = this.overlay;
        unstable = this.branchOverlay {
          branch = master;
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "electron-27.3.11"
            ];
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
            "logseq"
            "neovim"
            "nixos-artwork"
            "oh-my-zsh"
            "ripgrep"
            "rofi"
            "rust-analyzer"
            "sops"
            "starship"
            "tmux"
            "vscode"
            "wechat-uos"
            "zoxide"
            "zsh"
          ];
        };
        jetbrains = this.branchOverlay {
          branch = inputs.jetbrains;
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "dotnet-sdk-7.0.410"
              "dotnet-sdk-wrapped-7.0.410"
            ];
          };
          packages = [ "jetbrains" ];
        };
        vaultwarden = this.branchOverlay {
          branch = inputs.vaultwarden;
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          packages = [ "vaultwarden" ];
        };
        unstable-darwin = this.branchOverlay {
          branch = master;
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
          };
          packages = [
            "vscode"
          ];
        };
      };
      nixosModules = import ./modules/nixos;
      nixosConfigurations = {
        iosmanthus-xps = nixpkgs.lib.nixosSystem rec {
          specialArgs = {
            inherit self;
          };
          system = "x86_64-linux";
          modules = [
            ./nixos/iosmanthus-xps
            nixos-hardware.nixosModules.dell-xps-17-9710-intel
          ] ++ (mkWorkstationModules system);
        };

        iosmanthus-legion = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          modules = [ ./nixos/iosmanthus-legion ] ++ (mkWorkstationModules system);
        };

        aws-lightsail-0 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
          };
          modules = [
            ./secrets/aws-lightsail-0
            ./secrets/cloud/cloudflare
            ./secrets/cloud/endpoints
            ./secrets/cloud/grafana
            ./secrets/cloud/sing-box

            ./nixos/aws-lightsail-0

            sops-nix.nixosModules.sops

            self.nixosModules.atuin
            self.nixosModules.cloud.aws-lightsail
            self.nixosModules.cloud.sing-box
            self.nixosModules.gemini-openai-proxy
            self.nixosModules.o11y
            self.nixosModules.subgen

            {
              nixpkgs.overlays = [
                self.overlays.default
                self.overlays.unstable
                self.overlays.vaultwarden
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
            ./secrets/cloud/cloudflare
            ./secrets/cloud/grafana
            ./secrets/cloud/sing-box
            ./secrets/cloud/endpoints
            ./secrets/cloud/subgen

            ./nixos/gcp-instance-0

            sops-nix.nixosModules.sops

            self.nixosModules.cloud.gce
            self.nixosModules.cloud.sing-box
            self.nixosModules.o11y
            self.nixosModules.subgen
            self.nixosModules.unguarded
            self.nixosModules.chinadns

            {
              nixpkgs.overlays = [
                self.overlays.default
                self.overlays.unstable
              ];
            }
          ];
        };

        gcp-instance-2 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
          };
          modules = [
            ./secrets/gcp-instance-2
            ./secrets/cloud/cloudflare
            ./secrets/cloud/grafana
            ./secrets/cloud/sing-box
            ./secrets/cloud/endpoints

            ./nixos/gcp-instance-2

            sops-nix.nixosModules.sops

            self.nixosModules.cloud.gce
            self.nixosModules.cloud.sing-box
            self.nixosModules.o11y

            {
              nixpkgs.overlays = [
                self.overlays.default
                self.overlays.unstable
              ];
            }
          ];
        };

        lego-router = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit self;
          };
          modules = [
            ./nixos/lego-router
            ./secrets/lego-router

            sops-nix.nixosModules.sops
            self.nixosModules.cloud.base
            self.nixosModules.nixbuild
            self.nixosModules.sing-box

            {
              nixpkgs.overlays = [
                self.overlays.default
                self.overlays.unstable
              ];
            }
          ];
        };
      };
      darwinModules = import ./modules/darwin;
      darwinConfigurations = {
        iosmanthus-macmini = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self;
            hostName = "iosmanthus-macmini";
          };
          modules = [
            {
              nixpkgs.overlays = [
                self.overlays.default
                self.overlays.unstable-darwin
              ];
            }
            ./darwin/iosmanthus-macmini
            ./secrets/darwin

            self.darwinModules.admin.iosmanthus-darwin
            self.darwinModules.sing-box

            sops-nix.darwinModules.sops
            home-manager.darwinModules.home-manager
            mac-app-util.darwinModules.default
            (
              { config, ... }:
              {
                home-manager = {
                  users.iosmanthus =
                    { ... }:
                    {
                      imports = [
                        (./secrets + "/${config.admin.name}")
                        ./home/darwin
                      ];
                    };
                  sharedModules = [
                    self.darwinModules.admin.iosmanthus-darwin
                    self.darwinModules.home-manager
                    sops-nix.homeManagerModule
                    base16.homeManagerModule
                    mac-app-util.homeManagerModules.default
                  ];
                  extraSpecialArgs = {
                    inherit self;
                  };
                  useGlobalPkgs = true;
                  verbose = true;
                };
              }
            )
          ];
        };
      };
    }
    //
      flake-utils.lib.eachSystem
        [
          "x86_64-linux"
          "aarch64-darwin"
        ]
        (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
          in
          {
            devShells.default = pkgs.mkShell {
              hardeningDisable = [ "fortify" ];
              buildInputs = with pkgs; [
                fd
                gnumake
                go_1_22
                google-cloud-sdk
                gotools
                nix-output-monitor
                nixfmt-rfc-style
                nodejs
                sops
                statix
                terraform
                black
              ];
            };
          }
        );
}
