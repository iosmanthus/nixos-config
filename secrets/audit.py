#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p python3Packages.pyyaml -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-22.11.tar.gz

import re
import json
import yaml

from os import walk

ignore_paths = [
    ".*\.sh"
    '.*\.py',
    ".*\.pub",
    ".*\.nix",
    "\.sops\.yaml",
    ".*__pycache__.*",
]


def match(patterns, name):
    for pat in patterns:
        if re.match(pat, name):
            return True
    return False


def audit(base, whitelist):
    for (dirpath, _, files) in walk(base):
        for file in files:
            if match(whitelist, file) or match(whitelist, dirpath):
                continue
            if dirpath == './':
                path = dirpath + file
            else:
                path = dirpath + '/' + file

            try:
                with open(path, 'r') as f:
                    o = yaml.safe_load(f)
            except Exception:
                with open(path, 'r') as f:
                    o = json.load(f)

            if not o:
                raise Exception("invalid file " + path)

            if 'sops' not in o or 'age' not in o['sops']:
                msg = f'{path} is not encrypted by sops'
                raise Exception(msg)

            print(f'check {path}')


audit('./', ignore_paths)
