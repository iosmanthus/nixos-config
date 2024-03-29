.PHONY: switch

check: format lint

# https://github.com/NixOS/nixpkgs/issues/169193
switch:
	@nixos-rebuild switch --use-remote-sudo |& nom

format:
	@fd ".nix" --exec-batch "nixpkgs-fmt"
	@fd ".py" --exec-batch "yapf" "-i"

update:
	@nix flake update

lint:
	@statix check

upgrade: update switch