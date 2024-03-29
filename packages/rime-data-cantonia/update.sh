#!/usr/bin/env bash

if [ ! -d "plum" ]; then
    git clone --depth 1 https://github.com/rime/plum.git
else
    git -C plum pull
fi

rime_install="./plum/rime-install"

rime_frontend=fcitx5-rime rime_dir="./rime-data" bash $rime_install iDvel/rime-ice:others/recipes/all_dicts