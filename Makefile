.PHONY: switch

# https://github.com/NixOS/nixpkgs/issues/169193
switch:
	@nixos-rebuild switch --use-remote-sudo |& nom

format:
	@fd ".nix" --exec-batch "nixpkgs-fmt"

update:
	@nix flake update

upgrade: update switch