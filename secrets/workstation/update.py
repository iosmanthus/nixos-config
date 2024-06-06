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
    obj = json.loads(resp)
    if 'route' not in obj:
        raise Exception("No `route` field found in response")

    i = 0
    for rule in obj['route']['rules']:
        if rule['protocol'] == 'dns':
            break
        i += 1

    obj['route']['rules'].insert(i + 1, {
        'protocol': 'bittorrent',
        'outbound': 'direct',
    })

    return obj


url = decrypt("./secrets.yaml")['sing-box-url']
resp = get(url)
obj = override(resp)

with open(path, "w") as f:
    json.dump(obj, f, indent=2)

encrypt(path)
