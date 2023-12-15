#! /usr/bin/env nix-shell
#! nix-shell -i bash -p openssh rsync sops ssh-to-age

set -e -o pipefail

[[ -z "$INIT_USER" ]] && echo "INIT_USER not set" && exit 1
[[ -z "$INIT_HOST" ]] && echo "INIT_HOST not set" && exit 1
[[ -z "$INIT_PATH" ]] && echo "INIT_PATH not set" && exit 1

# Sync remote /etc/nixos if $INIT_PATH is empty
mkdir -p $INIT_PATH
if [ -z "$(ls -A $INIT_PATH)" ]; then
    rsync -Pav -e "ssh $INIT_SSH_OPTS" $INIT_USER@$INIT_HOST:/etc/nixos/ $INIT_PATH/
else
    echo "$INIT_PATH is not empty, skipping rsync"
fi

# derive age public key from the ed25519 ssh key of the host
ssh-keyscan $INIT_HOST | ssh-to-age
