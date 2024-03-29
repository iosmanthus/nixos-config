.PHONY: switch

check: format lint

# https://github.com/NixOS/nixpkgs/issues/169193
switch:
	@nixos-rebuild switch --use-remote-sudo |& nom

format:
	@fd --glob "*.nix" --exec-batch "nixpkgs-fmt"
	@fd --glob "*.py" --exec-batch "yapf" "-i"

update:
	@nix flake update

lint:
	@statix check

upgrade: update switch