#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pyyaml sops terraform

import subprocess
import sys
import yaml

secret_file = sys.argv[1]
decrypted = subprocess.run(["sops", "-d", secret_file],
                           stdout=subprocess.PIPE).stdout.decode('utf-8')
obj = yaml.safe_load(decrypted)

ipv4 = subprocess.run([
    "terraform", "-chdir=../../infra/aws-lightsail", "output", "-raw",
    "external_address_v4"
],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')

ipv6 = subprocess.run([
    "terraform", "-chdir=../../infra/aws-lightsail", "output", "-raw",
    "external_address_v6"
],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')

obj['aws-lightsail-0']['external-address-v4'] = ipv4
obj['aws-lightsail-0']['external-address-v6'] = ipv6

ipv4 = subprocess.run([
    "terraform", "-chdir=../../infra/gcp", "output", "-raw",
    "external_address_v4"
],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')

ipv6 = subprocess.run([
    "terraform", "-chdir=../../infra/gcp", "output", "-raw",
    "external_address_v6"
],
                      stdout=subprocess.PIPE).stdout.decode('utf-8')

obj['gcp-instance-0']['external-address-v4'] = ipv4
obj['gcp-instance-0']['external-address-v6'] = ipv6

yaml.dump(obj, open(secret_file, "w"), indent=4)
subprocess.run(["sops", "-e", "-i", secret_file])
