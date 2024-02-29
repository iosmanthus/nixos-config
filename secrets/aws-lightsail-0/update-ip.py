#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p python3Packages.pyyaml sops terraform

import subprocess
import sys
import yaml

secret_file = sys.argv[1]
decrypted = subprocess.run(["sops", "-d", secret_file],
                           stdout=subprocess.PIPE).stdout.decode('utf-8')
obj = yaml.safe_load(decrypted)

ipv4 = subprocess.run([
    "terraform", "-chdir=../../infra", "output", "-raw", "aws-lightsail-0-ipv4"
],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')

ipv6 = subprocess.run([
    "terraform", "-chdir=../../infra", "output", "-raw", "aws-lightsail-0-ipv6"
],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')

obj['aws-lightsail-0-ipv4'] = ipv4
obj['aws-lightsail-0-ipv6'] = ipv6

yaml.dump(obj, open(secret_file, "w"), indent=4)
subprocess.run(["sops", "-e", "-i", secret_file])
