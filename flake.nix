{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    latest-jetbrains.url = "github:iosmanthus/nixpkgs/latest-jetbrains-packages";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    berberman = {
      url = "github:berberman/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-vscode-server = {
      url = "github:iosmanthus/nixos-vscode-server/add-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        iosmanthus-nixos = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          # For more information of this field, check:
          # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/eval-config.nix
          modules = [
            ./configuration.nix
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
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
                  latest-jetbrains = import inputs.latest-jetbrains {
                    inherit system;
                    config.allowUnfree = true;
                  };
                  masterOverlay = (
                    self: super: genOverlay {
                      branch = master;
                      packages = [
                        "vscode"
                        "kitty"
                        "discord"
                        "firefox-bin"
                        "flameshot"
                        "starship"
                        "joplin-desktop"
                        "google-chrome"
                        "zoom-us"
                        "rofi"
                        "neovim"
                        "i3"
                        "joplin-desktop"
                        "thunderbird"
                        "jetbrains"

                        # Utils
                        "gh"
                        "exa"
                        "ripgrep"
                        "fd"
                        "bat"
                        "zoxide"
                      ];
                    }
                  );
                  # jetbrainsOverlay =
                  #   (
                  #     self: super: {
                  #       jetbrains = latest-jetbrains.jetbrains;
                  #     }
                  #   );
                in
                [
                  masterOverlay
                  inputs.berberman.overlay
                ] ++ (import ./overlays);
            }
          ];
        };
      };
    };
}
