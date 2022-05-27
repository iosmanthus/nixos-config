#! /usr/bin/env bash

# Helper to just fail with a message and non-zero exit code.
function fail() {
    echo "$1" >&2
    exit 1
}

CODE=$(command -v code || command -v codium)

EXT_LISTS=$($CODE --list-extensions)

if [ $# -ne 0 ]; then
    while IFS= read -r item; do
        EXT_LISTS=$(echo "$EXT_LISTS" | grep -v "$item")
    done <<< $(cat $1)
fi

echo $EXT_LISTS