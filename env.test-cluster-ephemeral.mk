CLUSTER_NAMESPACE ?= aks

export CLUSTER_NAME = test-cluster-ephemeral
export AZURE_CONTROL_PLANE_MACHINE_TYPE = Standard_D2s_v3
export AZURE_NODE_MACHINE_TYPE = Standard_D2s_v3
export CLUSTER_IDENTITY_NAME = cluster-identity
export AZURE_LOCATION = westeurope
export AZURE_RESOURCE_GROUP = testClusterAPI
export AZURE_CLUSTER_IDENTITY_SECRET_NAMESPACE = $(CLUSTER_NAMESPACE)
export AZURE_CLUSTER_IDENTITY_SECRET_NAME = cluster-identity-secret-$(CLUSTER_NAME)
