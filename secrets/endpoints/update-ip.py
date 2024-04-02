#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pyyaml sops terraform

import subprocess
import sys
import yaml

secret_file = sys.argv[1]
obj = {}

instances = [{
    'name': "aws_lightsail_0",
    'src': "../../infra/aws-lightsail",
}, {
    'name': "gcp_instance_0",
    'src': "../../infra/gcp",
}, {
    'name': "gcp_instance_1",
    'src': "../../infra/gcp",
}]

for instance in instances:
    ipv4 = subprocess.run([
        "terraform", f"-chdir={instance['src']}", "output", "-raw",
        f"{instance['name']}_external_address_v4"
    ],
                          stdout=subprocess.PIPE).stdout.decode('utf-8')

    ipv6 = subprocess.run([
        "terraform", f"-chdir={instance['src']}", "output", "-raw",
        f"{instance['name']}_external_address_v6"
    ],
                          stdout=subprocess.PIPE).stdout.decode('utf-8')

    instance_name = instance['name'].replace('_', '-')
    obj[instance_name] = {}
    obj[instance_name]['external-address-v4'] = ipv4
    obj[instance_name]['external-address-v6'] = ipv6

yaml.dump(obj, open(secret_file, "w"), indent=4)
subprocess.run(["sops", "-e", "-i", secret_file])
