#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pyyaml unzip -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz

import argparse
import json
import shutil
import subprocess
import sys
import yaml

from tempfile import TemporaryDirectory


def check_code_command():
    commands = ['code', 'codium', 'code-insiders']
    for cmd in commands:
        if shutil.which(cmd):
            return cmd


def execute_dump(args: argparse.Namespace) -> None:
    o = dump_extensions(code_command=check_code_command())
    if args.format == 'json':
        print(json.dumps(o, indent=4))
    elif args.format == 'yaml':
        print(yaml.dump(o, indent=4))


def dump_extensions(code_command: str) -> dict:
    output = subprocess.run([code_command, '--list-extensions'],
                            stdout=subprocess.PIPE)
    lines = output.stdout.decode('utf-8').splitlines()

    o = {'extensions': []}
    for line in lines:
        [publisher, name] = line.split('.')
        o['extensions'].append({'publisher': publisher, 'name': name})

    return o


def execute_update(args: argparse.Namespace):
    with open(args.__dict__['from'], 'r+') as f:
        if args.format == 'json':
            extensions = json.load(f)
        elif args.format == 'yaml':
            extensions = yaml.load(f, Loader=yaml.SafeLoader)
        f.seek(0)

        updates = check_update(extensions)

        if args.inplace:
            if args.format == 'json':
                dumper = json.dump
            elif args.format == 'yaml':
                dumper = yaml.dump

            dumper(updates, f, indent=4)
            f.truncate()
        else:
            print(updates)


def check_update(extensions: dict) -> dict:
    if extensions.get('extensions') is None:
        raise AttributeError('extensions is not found')
    for ext in extensions['extensions']:
        cache = download_update(ext)
        version = get_ext_version_from_cache(path=cache['path'])
        ext['version'] = version
        ext['sha256'] = cache['sha256']
    return extensions


def download_update(extension: dict) -> dict:
    publisher = extension['publisher']
    name = extension['name']
    api = f'https://{publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/{publisher}/extension/{name}/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage'
    return nix_prefetch_url(url=api)


def nix_prefetch_url(url: str) -> dict:
    command = ['nix-prefetch-url', '--type', 'sha256', '--print-path', url]
    [sha256, path] = subprocess.run(
        command, stdout=subprocess.PIPE).stdout.decode('utf-8').splitlines()
    return {'sha256': sha256, 'path': path}


def get_ext_version_from_cache(path: str) -> str:
    with TemporaryDirectory() as tmpdir:
        subprocess.run(['unzip', path, '-d', tmpdir], stdout=subprocess.PIPE)
        with open(f'{tmpdir}/extension/package.json', 'r') as f:
            package = json.load(f)
    return package['version']


def main():
    parser = argparse.ArgumentParser(
        description='Manager of vscode extensions')
    subparser = parser.add_subparsers(dest='subcommand')

    parser_dump = subparser.add_parser('dump', help='dump extensions')
    parser_dump.add_argument('--format',
                             help='output format',
                             default='json',
                             choices=['json', 'yaml'])

    parser_update = subparser.add_parser('update', help='update extensions')
    parser_update.add_argument('--from',
                               help='update from spec file',
                               required=True)
    parser_update.add_argument('--format',
                               help='spec file format',
                               default='json',
                               choices=['json', 'yaml'])
    parser_update.add_argument('-i',
                               '--inplace',
                               help='update inplace',
                               action='store_true')

    args = parser.parse_args()

    if args.subcommand == 'dump':
        execute_dump(args)
    elif args.subcommand == 'update':
        execute_update(args)


if __name__ == "__main__":
    main()