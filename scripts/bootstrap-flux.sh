#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source "${SCRIPT_DIR}/../.env"
source "${SCRIPT_DIR}/../tf-output/.env"


cluster=dev

if [ $# -eq 1 ]; then
    cluster=$1
fi

RESOURCE_GROUP="flux-${cluster}"
AKS_CLUSTER_NAME="${cluster}-aks"

az account set --subscription $SUBSCRIPTION_ID

az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER_NAME
FILES="${SCRIPT_DIR}/../flux-bootstrap/${cluster}/*"
for f in $FILES
do
    cat ${f} | sed "s/__registry-url__/$acr_url/g" | kubectl apply -f -
done
