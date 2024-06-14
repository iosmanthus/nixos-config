#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p python3Packages.pyyaml python3Packages.requests sops

import yaml
import subprocess
import requests
import json

path = "sing-box"


def decrypt(f):
    data = subprocess.Popen(["sops", "-d", f], stdout=subprocess.PIPE).stdout
    return yaml.safe_load(data)


def encrypt(f):
    subprocess.run(["sops", "-i", "-e", f])


def get(url):
    return requests.get(url).content


def override(resp):
    return json.loads(resp)


url = decrypt("./secrets.yaml")['sing-box-url']
resp = get(url)
obj = override(resp)

with open(path, "w") as f:
    json.dump(obj, f, indent=2)

encrypt(path)
