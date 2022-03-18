.PHONY: switch

switch:
	@sudo nixos-rebuild switch |& nom

format:
	@fd ".nix" --exec-batch "nixpkgs-fmt"

update:
	@nix flake update

upgrade: update switch