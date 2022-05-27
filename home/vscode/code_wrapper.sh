#! /usr/bin/env bash

CODE=$(command -v code || command -v codium)

if [ $# -ge 2 ]; then
    IGNORE=$(cat $2)
    echo $IGNORE
fi

$CODE $1