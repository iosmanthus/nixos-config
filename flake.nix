{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    master.url = "github:NixOS/nixpkgs/master";
    stable.url = "github:NixOS/nixpkgs/nixos-21.05";
    sops-nix.url = "github:Mic92/sops-nix";
    firefox-nightly = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
              nixpkgs.overlays = [
                (
                  self: super: {
                    firefox-nightly = inputs.firefox-nightly.defaultPackage.${system};
                  }
                )
              ];
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
                        "jetbrains.goland"
                        "jetbrains.idea-ultimate"
                        "jetbrains.clion"
                        "google-chrome"
                        "zoom-us"
                        "rofi"
                        "neovim"
                        "i3"
                        "joplin-desktop"

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
