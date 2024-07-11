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
    cfg = json.loads(resp)
    tun = cfg['inbounds'][0]
    if tun['type'] != "tun":
        return
    tun['auto_redirect'] = True
    tun['route_exclude_address_set'] = ["geoip-cn"]
    tun['address'] = [tun['inet4_address']]
    tun['route_exclude_address'] = ['10.2.0.0/16']
    del tun['inet4_address']
    return cfg


url = decrypt("./secrets.yaml")['sing-box-url']
resp = get(url)
obj = override(resp)

with open(path, "w") as f:
    json.dump(obj, f, indent=2)

encrypt(path)
