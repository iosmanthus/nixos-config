#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p sops python3Packages.pyyaml python3Packages.requests -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

import os
import sys
import subprocess
import requests
import yaml
import rules

from yaml import FullLoader


def get_sub(url):
    resp = requests.get(url)
    return yaml.load(resp.text, Loader=FullLoader)


def main():
    try:
        config_file = sys.argv[1]
        rule_dir = sys.argv[2]
        sub_link = sys.argv[3]
    except IndexError:
        print('Usage: update_sub.py <config_file> <rule_dir> <sub_link>')
        sys.exit(1)

    m = get_sub(sub_link)

    m['port'] = 80
    m['socks-port'] = 1080
    m['mixed-port'] = 0
    m['allow-lan'] = True
    m['external-controller'] = '0.0.0.0:9090'
    m['script'] = None

    outbounds = list(map(lambda p: p['name'], m['proxies']))
    auto_probe = {
        'name': "Auto",
        'type': 'url-test',
        'proxies': outbounds,
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 10
    }

    select = {
        'type': 'select',
        'name': 'Proxy',
        'proxies': [auto_probe['name']] + outbounds
    }

    rules.update_rules(rule_dir, [
        'private', 'reject', 'proxy', 'direct', 'lancidr', 'cncidr',
        'telegramcidr'
    ])

    m |= {
        'proxy-groups': [select, auto_probe],
        'rules': [
            'RULE-SET,private,DIRECT', 'RULE-SET,reject,REJECT',
            f'RULE-SET,proxy,{select["name"]}', 'RULE-SET,direct,DIRECT',
            'RULE-SET,lancidr,DIRECT', 'RULE-SET,cncidr,DIRECT',
            f'RULE-SET,telegramcidr,{select["name"]}', 'GEOIP,LAN,DIRECT',
            'GEOIP,CN,DIRECT', f'MATCH,{select["name"]}'
        ],
        'rule-providers': {
            'private': {
                'type': 'file',
                'behavior': 'domain',
                'path': f'./{rule_dir}/private.txt',
            },
            'reject': {
                'type': 'file',
                'behavior': 'domain',
                'path': f'./{rule_dir}/reject.txt',
            },
            'proxy': {
                'type': 'file',
                'behavior': 'domain',
                'path': f'./{rule_dir}/proxy.txt',
            },
            'direct': {
                'type': 'file',
                'behavior': 'domain',
                'path': f'./{rule_dir}/direct.txt',
            },
            'lancidr': {
                'type': 'file',
                'behavior': 'ipcidr',
                'path': f'./{rule_dir}/lancidr.txt',
            },
            'cncidr': {
                'type': 'file',
                'behavior': 'ipcidr',
                'path': f'./{rule_dir}/cncidr.txt',
            },
            'telegramcidr': {
                'type': 'file',
                'behavior': 'ipcidr',
                'path': f'./{rule_dir}/telegramcidr.txt',
            }
        }
    }

    with open(config_file, 'w') as f:
        f.write(yaml.dump(m))

    os.system(f'sops -i -e {config_file}')


if __name__ == "__main__":
    main()
