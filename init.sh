#! /usr/bin/env nix-shell
#! nix-shell -i bash -p openssh ssh-to-age

set -e -o pipefail

# derive age public key from the ed25519 ssh key of the host
ssh-keyscan $INIT_HOST | ssh-to-age
