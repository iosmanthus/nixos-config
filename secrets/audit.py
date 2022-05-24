#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3 python3Packages.pyyaml -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

from os import walk
import re

import json
import yaml
from yaml import FullLoader


def match(patterns, name):
    for pat in patterns:
        if re.match(pat, name):
            return True
    return False


ignore_files = ['.*\.py', ".*\.pub", ".*\.nix", "\.sops\.yaml"]
for (dirpath, _, files) in walk('./'):
    for file in files:
        if match(ignore_files, file):
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

        print(f'{path} is encrypted')

print('safe!')
