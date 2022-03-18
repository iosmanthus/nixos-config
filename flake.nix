{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    master.url = "github:NixOS/nixpkgs/master";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    berberman = {
      url = "github:berberman/flakes/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils/master";

    nixos-vscode-server = {
      url = "github:iosmanthus/nixos-vscode-server/add-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , home-manager
    , sops-nix
    , ...
    }@inputs:
    {
      nixosConfigurations = {
        iosmanthus-nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          # For more information of this field, check:
          # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/eval-config.nix
          modules = [
            ./configuration.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              imports = [ inputs.nixos-vscode-server.nixosModules.system ];
              services.auto-fix-vscode-server.enable = true;
            }
            {
              home-manager = {
                useGlobalPkgs = true;
                verbose = true;
                users.iosmanthus = import ./home;
              };
            }
            {
              nixpkgs.overlays =
                let
                  genOverlay = import ./utils/branch-overlay.nix;
                  master = import inputs.master {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  stable = import inputs.stable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  stableOverlay = (self: super:
                    genOverlay {
                      branch = stable;
                      packages = [
                        "thunderbird"
                        "kitty"
                        "linuxPackages_latest"
                        "polybar"
                      ];
                    });
                  masterOverlay = (self: super:
                    genOverlay {
                      branch = master;
                      packages = [
                        "vscode"
                        "discord"
                        "firefox-bin"
                        "starship"
                        "joplin-desktop"
                        "google-chrome"
                        "zoom-us"
                        "rofi"
                        "neovim"
                        "i3"
                        # "jetbrains"

                        # Utils
                        "gh"
                        "exa"
                        "ripgrep"
                        "rnix-lsp"
                        "fd"
                        "sops"
                        "bat"
                        "zoxide"
                        "remarshal"
                        "spice-gtk"
                      ];
                    });
                in
                [ stableOverlay masterOverlay inputs.berberman.overlay ]
                ++ (import ./overlays);
            }
          ];
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ gnumake nix-output-monitor nixpkgs-fmt fd ];
      };
    });
}
