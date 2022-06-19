#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p python3 -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

import sys
from urllib.parse import quote

try:
    base_url = sys.argv[1]
    code_url = sys.argv[2]
    sub_links = sys.argv[3:]
except Exception:
    print("Usage: mk_sub_links.py <base_url> <code_url> <sub_links>...")

s = base_url + "?code=" + quote(code_url)
for link in sub_links:
    s += "&sub=" + quote(link)

print(s)