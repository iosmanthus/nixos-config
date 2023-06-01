#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p python3Packages.pyyaml python3Packages.requests sops -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-22.11.tar.gz

import yaml
import subprocess
import requests
from subprocess import PIPE, Popen

path = "sing-box"


def decrypt(file):
    data = Popen(["sops", "-d", file], stdout=PIPE).stdout
    return yaml.safe_load(data)


url = decrypt("./secrets.yaml")['sing-box-url']
resp = requests.get(url).content
with open(path, "wb") as f:
    f.write(resp)

subprocess.run(["sops", "-i", "-e", path])
