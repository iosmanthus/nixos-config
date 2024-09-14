#!/usr/bin/env bash

function recover {
    sops -e -i terraform.tfvars.json
    sops -e -i terraform.tfstate
}

sops -d -i terraform.tfvars.json
sops -d -i terraform.tfstate
trap recover EXIT
terraform $@
