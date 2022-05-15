{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    master.url = "github:NixOS/nixpkgs/master";
    sops-nix.url = "github:Mic92/sops-nix/master";
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
    let
      mkOverlay = import ./utils/branch-overlay.nix;

      mkBranch = system: branch: import inputs.${branch} {
        inherit system;
        config.allowUnfree = true;
      };

      mkMasterOverlay = (system: self: super:
        mkOverlay {
          branch = mkBranch system "master";
          packages = [
            "vscode"
            "discord"
            "firefox-bin"
            "starship"
            "google-chrome"
            "notion-app-enhanced"
            "zoom-us"
            "rofi"
            "neovim"
            "i3"
            "jetbrains"

            # Utils
            "oh-my-zsh"
            "kitty"
            "zsh"
            "gh"
            "tmux"
            "exa"
            "ripgrep"
            "polybar"
            "rnix-lsp"
            "fd"
            "sops"
            "bat"
            "zoxide"

            # Virtualisation
            # "virt-viewer"
            # "virt-manager"
            # "remarshal"
            # "spice-gtk"

            # Kernel
            # "linuxPackages_latest"
          ];
        });

      mkCommonModules =
        system: [
          ./configuration.nix
          ./hardware-common.nix
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
          {
            imports = [ inputs.nixos-vscode-server.nixosModules.system ];
            services.auto-fix-vscode-server.enable = true;
          }
          ({ config, ... }: {
            home-manager = {
              sharedModules = [
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
              map (mkBuilder: mkBuilder system) [ mkMasterOverlay ]
              ++ [ inputs.berberman.overlay ]
              ++ [ (import ./overlays.nix) ];
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
            ] ++ (mkCommonModules system);
          };
          iosmanthus-xps = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              { networking.hostName = "iosmanthus-xps"; }
              ./machines/iosmanthus-xps
              ./secrets/iosmanthus
            ] ++ (mkCommonModules system);
          };
        };
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [ gnumake nix-output-monitor nixpkgs-fmt fd sops ];
      };
    });
}
