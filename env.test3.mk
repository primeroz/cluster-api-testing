
CLUSTER_NAME = test3
AZURE_CLUSTER_IDENTITY_SECRET_NAME = cluster-identity-secret-$(CLUSTER_NAME)
KUBERNETES_VERSION=1.25
KUBERNETES_PODS_CIDR_BLOCK=10.244.0.0/16
KUBERNETES_SERVICES_CIDR_BLOCK=10.100.0.0/16

# Applications to deploy, order is important
APPS = \
  azure-resource-group \
  clusterctl \
  azure-cluster \
  azure-cloud-provider \
  azure-core-apps

