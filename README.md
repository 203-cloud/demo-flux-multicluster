# demo-flux-multicluster
Root project for demoing flux with promotion between clusters

This repo holds the terraform code to provision the environment and the scripts to bootstrap the initial flux config

## Setup and bootstrak

Create an .env file at the root of the repo with the subscription_id of where the infra should be deployed.

See an example of the file in .env-template file

1. Apply the terraform code `make tf-apply`

2. Bootstrap the flux config for dev `make bootstrap-dev`

3. Bootstrap the flux config for staging `make bootstrap-staging`

4. Stop/start the clusters with `make stop` and `make start`