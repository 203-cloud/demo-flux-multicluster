#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../.env"

pushd ${SCRIPT_DIR}/..
pushd terraform

az account set --subscription $SUBSCRIPTION_ID
terraform init
teraform validate
terraform apply --destroy -var subscription_id=$SUBSCRIPTION_ID

popd
pushd tmp
rm -rf .env
popd 
popd