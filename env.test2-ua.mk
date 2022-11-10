CLUSTER_NAMESPACE ?= aks

export KIND_NAME = cluster-api
export CLUSTER_NAME = test2-ua
export AZURE_CONTROL_PLANE_MACHINE_TYPE = Standard_D2s_v3
export AZURE_NODE_MACHINE_TYPE = Standard_D2s_v3
export CLUSTER_IDENTITY_NAME = cluster-identity
export AZURE_LOCATION = westeurope
export AZURE_RESOURCE_GROUP = testClusterAPI
export AZURE_CLUSTER_IDENTITY_SECRET_NAMESPACE = $(CLUSTER_NAMESPACE)
export AZURE_CLUSTER_IDENTITY_SECRET_NAME = cluster-identity-secret-$(CLUSTER_NAME)
export KUBERNETES_VERSION=1.23
export KUBERNETES_CIDR_BLOCK=10.244.0.0/16
export KUBERNETES_SERVICE_CIDR_BLOCK=10.96.0.0/16

# Applications to deploy, order is important
APPS = \
  azure-resource-group \
  clusterctl \
  azure-cluster \
  azure-cloud-provider \
  azure-core-apps

