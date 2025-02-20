#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../.env"

az account set --subscription $SUBSCRIPTION_ID

if [ $# -ne 1 ]; then
    echo "Usage: $0 <dev|staging>"
    exit 1
fi

if [ $1 == "dev" ]; then
    az aks get-credentials --resource-group flux-dev --name dev-aks
elif [ $1 == "staging" ]; then
    az aks get-credentials --resource-group flux-staging --name staging-aks
else
    echo "Usage: $0 <dev|staging>"
    exit 1
fi