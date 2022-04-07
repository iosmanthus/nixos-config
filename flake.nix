{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    stable.url = "github:NixOS/nixpkgs/nixos-21.11";
    master.url = "github:NixOS/nixpkgs/master";
    sops-nix.url = "github:Mic92/sops-nix/master";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
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
      nixosConfigurations = let commonModuleBuilder = system: [
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
            sharedModules = [ ./machines/${config.machine.userName} ];
            users.${config.machine.userName} = import ./home;
            useGlobalPkgs = true;
            verbose = true;
          };
        })
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
                    "notion-app-enhanced"
                    "zoom-us"
                    "rofi"
                    "neovim"
                    "i3"
                    # "jetbrains"

                    # Utils
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
                    "virt-viewer"
                    "remarshal"
                    "spice-gtk"

                    # Kernel
                    # "linuxPackages_latest"
                  ];
                });
            in
            [ stableOverlay masterOverlay inputs.berberman.overlay ]
            ++ (import ./overlays);
        }
      ]; in
        {
          # For more information of this field, check:
          # https://github.com/NixOS/nixpkgs/blob/master/nixos/lib/eval-config.nix
          iosmanthus-legion = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              { networking.hostName = "iosmanthus-legion"; }
              ./machines/iosmanthus
              ./machines/iosmanthus/legion
              ./secrets/iosmanthus
            ] ++ (commonModuleBuilder system);
          };
          iosmanthus-xps = nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              { networking.hostName = "iosmanthus-xps"; }
              ./machines/iosmanthus
              ./machines/iosmanthus/xps
              ./secrets/iosmanthus
            ] ++ (commonModuleBuilder system);
          };
        };
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [ gnumake nix-output-monitor nixpkgs-fmt fd ];
      };
    });
}
