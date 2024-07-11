#!/usr/bin/env nix-shell
#! nix-shell -i bash -p google-cloud-sdk

set -euo pipefail

PROJECT_ID=${PROJECT_ID:-"clean-node-425415-i9"}
BUCKET_NAME=${BUCKET_NAME:-"nixos-cloud-images-20240701160523"}

img_path=$(echo result/*.tar.gz)
img_name=${IMAGE_NAME:-$(basename "$img_path")}
img_id=$(echo "$img_name" | sed 's|.raw.tar.gz$||;s|\.|-|g;s|_|-|g')
img_family=$(echo "$img_id" | cut -d - -f1-4)

gsutil cp "$img_path" "gs://${BUCKET_NAME}/$img_name"
