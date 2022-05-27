#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p sops python3 python3Packages.pyyaml python3Packages.requests -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

import requests
import json

repo = 'Loyalsoldier/clash-rules'
rule_sets = [
    'applications',
    'private',
    'reject',
    'icloud',
    'apple',
    'google',
    'proxy',
    'direct',
    'lancidr',
    'cncidr',
    'telegramcidr'
]
api_url = f'https://api.github.com/repos/{repo}/releases/latest'

latest_build_info = requests.get(api_url).json()
latest_tag = latest_build_info['tag_name']

