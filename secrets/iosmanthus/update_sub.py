#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p sops python3 python3Packages.pyyaml python3Packages.requests

import os
import sys

import requests
import yaml
from yaml import FullLoader

config_file = sys.argv[1]
sub = sys.argv[2]

resp = requests.get(sub)
m = yaml.load(resp.text, Loader=FullLoader)
m['port'] = 80
m['socks-port'] = 1080
m['mixed-port'] = 0
m['allow-lan'] = True
m['external-controller'] = '0.0.0.0:9090'

with open(config_file, 'w') as f:
    f.write(yaml.dump(m))

os.system(f'sops -i -e {config_file}')
