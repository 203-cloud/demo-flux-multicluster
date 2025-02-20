#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../.env"

az account set --subscription $SUBSCRIPTION_ID

az aks start --resource-group flux-dev --name dev-aks

az aks start --resource-group flux-staging --name staging-aks