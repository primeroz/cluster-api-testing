
CLUSTER_NAME = test2-ua
AZURE_CLUSTER_IDENTITY_SECRET_NAME = cluster-identity-secret-$(CLUSTER_NAME)
KUBERNETES_VERSION=1.23
KUBERNETES_POD_CIDR_BLOCK=10.244.0.0/16
KUBERNETES_SERVICE_CIDR_BLOCK=10.96.0.0/16

# Applications to deploy, order is important
APPS = \
  azure-resource-group \
  clusterctl \
  azure-cluster \
  azure-cloud-provider \
  azure-core-apps

