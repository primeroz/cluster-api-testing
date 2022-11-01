{
  _config+:: {},

  apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
  kind: 'AzureClusterIdentity',
  metadata: {
    labels: {
      'clusterctl.cluster.x-k8s.io/move-hierarchy': 'true',
    },
    name: $._config.cluster_identity_name,
    namespace: $._config.cluster_identity_namespace,
  },
  spec: {
    allowedNamespaces: {},
    clientID: $._config.azure_client_id,
    clientSecret: {
      name: $._config.cluster_identity_secret_name,
      namespace: $._config.cluster_identity_secret_namespace,
    },
    tenantID: $._config.azure_tenant_id,
    type: 'ServicePrincipal',
  },
}
