#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.requests -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

import requests
import json
import os

repo = 'Loyalsoldier/clash-rules'


def get_latest_release_tag(repo):
    api_url = f'https://api.github.com/repos/{repo}/releases/latest'
    latest_build_info = requests.get(api_url).json()
    return latest_build_info['tag_name']


def get_rule_file(repo, tag, name):
    url = f'https://github.com/{repo}/releases/download/{tag}/{name}'
    return requests.get(url).text


def write_to(base_dir, filename, content):
    try:
        tmp_path = f'{base_dir}/.{filename}.tmp'
        path = f'{base_dir}/{filename}'
        with open(tmp_path, 'w') as tmp:
            tmp.write(content)
            tmp.flush()
            os.rename(tmp_path, path)
    finally:
        if os.path.exists(tmp_path):
            os.remove(tmp_path)


def update_rules(base_dir, rule_sets):
    latest_release_tag = get_latest_release_tag(repo)
    if not os.path.exists(base_dir):
        os.mkdir(base_dir)
    for rule_set in rule_sets:
        print(f'updating {rule_set}')
        content = get_rule_file(repo, latest_release_tag, f'{rule_set}.txt')
        write_to(base_dir, f'{rule_set}.txt', content)