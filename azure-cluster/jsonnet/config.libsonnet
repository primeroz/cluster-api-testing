{

  _config+:: {
    cluster_name:: error 'cluster_name is required',
    namespace:: error 'namespace is required',
    location:: 'westeurope',
    azure_client_id:: error 'azure_client_id is required',
    azure_tenant_id:: error 'azure_tenant_id is required',
    cluster_identity_name:: 'cluster-identity-%s' % $._config.cluster_name,
    cluster_identity_namespace:: $._config.namespace,
    cluster_identity_secret_name:: error 'cluster_identity_secret_name is required',
    cluster_identity_secret_namespace:: $._config.namespace,
    resource_group:: error 'resource_group is required',
    subscription_id:: error 'subscription_id is required',
    sshPublicKey: '',

    cluster+: {
      addTags:: true,
      addPaused:: true,
      machineHC:: true,
      paused:: false,
      type:: 'public',
      service_account_issuer:: null,
      version: error 'cluster version is required',
      podsCidrBlocks: ['192.168.0.0/16'],
      servicesCidrBlocks: ['10.96.0.0/16'],
      nodeSubnet: '10.1.0.0/16',
      controPlaneSubnet: '10.0.0.0/24',
      vnetSubnet: '10.0.0.0/8',
      privateApiLbIp: '10.0.0.100',
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
      sshPublicKey: $._config.sshPublicKey,
    },

    nodes+: {
      replicas: 1,
      os: {
        diskSizeGB: 50,
      },
      vmSize: 'Standard_D2s_v3',
      sshPublicKey: $._config.sshPublicKey,
    },

  },

}
