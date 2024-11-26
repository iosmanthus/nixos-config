#! /usr/bin/env nix-shell
#! nix-shell -i python3 --pure -p python3Packages.pyyaml sops

import json
import os
import re
import subprocess
import sys
import yaml

from os import walk

ignore_paths = [
    ".*.py",
    ".*.pub",
    ".*.nix",
    ".sops.yaml",
    ".*__pycache__.*",
]

cmd = sys.argv[1]


def match(name, patterns):
    for pat in patterns:
        if re.match(pat, name):
            return True
    return False


def audit(base, ignores):
    for dirpath, _, files in walk(base):
        if match(dirpath, ignores):
            continue
        for file in files:
            if match(file, ignores):
                continue

            path = os.path.join(dirpath, file)
            try:
                with open(path, "r") as f:
                    o = yaml.safe_load(f)
            except Exception:
                with open(path, "r") as f:
                    o = json.load(f)
            if not o:
                raise Exception("invalid file " + path)

            if "sops" not in o or "age" not in o["sops"]:
                msg = f"{path} is not encrypted by sops"
                raise Exception(msg)

            print(f"check {path}")


def rotate(base, ignores):
    for dirpath, _, files in walk(base):
        if not os.path.isfile(f"{dirpath}/.sops.yaml"):
            continue
        if match(dirpath, ignores):
            continue
        for file in files:
            if match(file, ignores):
                continue

            path = os.path.join(dirpath, file)
            try:
                subprocess.run(
                    ["sops", "--config", f"{dirpath}/.sops.yaml", "-d", "-i", path],
                    check=True,
                )
                subprocess.run(
                    ["sops", "--config", f"{dirpath}/.sops.yaml", "-e", "-i", path],
                    check=True,
                )
            except Exception as e:
                print(f"failed to rotate {path}: {e}")
                continue

            print(f"rotate {path}")


def main():
    if cmd == "audit":
        audit("./", ignore_paths)
    if cmd == "rotate":
        rotate("./", ignore_paths)


if __name__ == "__main__":
    main()
