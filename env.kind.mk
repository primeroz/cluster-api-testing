# Safety net, make sure we are using the correct kubectl context before
# deploying anything
KUBE_CONTEXT ?= kind-cluster-api
CLUSTER_NAME ?= cluster-api
AZURE_RG_NAME ?= testClusterAPI
AZURE_LOCATION ?= "westeurope"

# Azure Keyvault name where secrets are stored (ie: cloudflare password)
#AZURE_KEY_VAULT_NAME ?= my-infra

# Applications to deploy, order is important
APPS = \
	azure-resource-group \
  clusterctl \
  azure-cluster

# Ref: https://github.com/helm/charts/tree/master/stable/nginx-ingress
NGINX_INGRESS_CHART_VERSION = 4.3.0
