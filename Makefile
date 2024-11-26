.PHONY: switch

check: format lint

# https://github.com/NixOS/nixpkgs/issues/169193
switch:
	@nixos-rebuild switch --use-remote-sudo |& nom

format:
	@echo "Format nix files"
	fd --glob "*.nix" --exec-batch "nixfmt"
	@echo "Format python files"
	fd --glob "*.py" --exec-batch "black"

update:
	@nix flake update

lint:
	@statix check

upgrade: update switch