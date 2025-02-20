#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../.env"

pushd ${SCRIPT_DIR}/../terraform

az account set --subscription $SUBSCRIPTION_ID

terraform init
terraform validate
terraform apply -var subscription_id=$SUBSCRIPTION_ID
mkdir -p ../tf-output
terraform output | tr -d ' ' >> ../tf-output/.env
popd 