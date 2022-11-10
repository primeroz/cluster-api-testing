#common variables shared accross Makefiles
SHELL := bash -eo pipefail

AZURE_CHECK_ACCOUNT ?= "Azure FC 1"

ifndef ENVIRONMENT
$(error the variable ENVIRONMENT is not defined, run using `ENVIRONMENT=kind make deploy-all')
endif

CLUSTER_NAMESPACE ?= aks
KIND_NAME ?= cluster-api
AZURE_CONTROL_PLANE_MACHINE_TYPE ?= Standard_D2s_v3
AZURE_NODE_MACHINE_TYPE ?= Standard_D2s_v3
CLUSTER_IDENTITY_NAME ?= cluster-identity
AZURE_LOCATION ?= westeurope
AZURE_RESOURCE_GROUP ?= testClusterAPI
AZURE_CLUSTER_IDENTITY_SECRET_NAMESPACE ?= $(CLUSTER_NAMESPACE)
KUBERNETES_VERSION ?= 1.23
KUBERNETES_PODS_CIDR_BLOCK ?= 192.168.0.0/16
KUBERNETES_SERVICES_CIDR_BLOCK ?= 10.96.0.0/16


#SECRET_SHOW := az keyvault secret show --vault-name $(AZURE_KEY_VAULT_NAME) --query 'value' -o tsv --name
