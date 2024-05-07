#!/usr/bin/env bash

function cleanup {
    rm -rf ./states
    sops -e -i terraform.tfvars.json
    sops -e -i terraform.tfstate
}

trap cleanup EXIT

mkdir -p ./states/aws-lightsail
mkdir -p ./states/gcp

sops -d ../aws-lightsail/terraform.tfstate > ./states/aws-lightsail/terraform.tfstate
sops -d ../gcp/terraform.tfstate > ./states/gcp/terraform.tfstate
sops -d -i terraform.tfvars.json
sops -d -i terraform.tfstate

terraform apply -auto-approve $@
