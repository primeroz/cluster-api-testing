{

  _config+:: {
    cluster_name:: error 'cluster_name is required',
    namespace:: error 'namespace is required',
    location:: 'westeurope',
    azure_client_id:: std.extVar('AZURE_CLIENT_ID'),
    azure_tenant_id:: std.extVar('AZURE_TENANT_ID'),
    cluster_identity_name:: 'cluster-identity-%s' % $._config.cluster_name,
    cluster_identity_namespace:: $._config.namespace,
    cluster_identity_secret_name:: std.extVar('AZURE_CLUSTER_IDENTITY_SECRET_NAME'),
    cluster_identity_secret_namespace:: $._config.namespace,
    resource_group:: std.extVar('AZURE_RESOURCE_GROUP'),
    subscription_id:: std.extVar('AZURE_SUBSCRIPTION'),

    cluster+: {
      version: 'v1.23.12',
      podCidrBlocks: ['192.168.0.0/16'],
      labels+: {
        cni: 'calico',
      },
    },

    controlplane: {
      replicas: 3,
      etcddisk: {
        sizeGB: 256,
      },
      os: {
        diskSizeGB: 50,
      },
      vmSize: 'Standard_D2s_v3',
    },

    nodes+: {
      replicas: 1,
      os: {
        diskSizeGB: 50,
      },
      vmSize: 'Standard_D2s_v3',
    },

  },

}
