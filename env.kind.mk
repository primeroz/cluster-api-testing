# Safety net, make sure we are using the correct kubectl context before
# deploying anything
KUBE_CONTEXT ?= kind-cluster-api

# Azure Keyvault name where secrets are stored (ie: cloudflare password)
#AZURE_KEY_VAULT_NAME ?= my-infra

