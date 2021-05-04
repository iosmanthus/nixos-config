{
  description = "iosmanthus 💓 NixOS";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    berberman = {
      url = "github:berberman/flakes";
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
              home-manager = {
                useGlobalPkgs = true;
                verbose = true;
                users.iosmanthus = import ./home;
              };
            }
            {
              nixpkgs.overlays = [ inputs.berberman.overlay ] ++ (import ./overlays { inherit system; });
            }
          ];
        };
      };
    };
}
