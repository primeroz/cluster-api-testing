{
  _config+:: {},

  apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
  kind: 'AzureCluster',
  metadata: {
    name: '%s' % $._config.cluster_name,
    namespace: $._config.namespace,
  },
  spec: {
    [if $._config.cluster.bastion then 'bastionSpec']: {
      azureBastion: {},
    },
    identityRef: {
      apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
      kind: 'AzureClusterIdentity',
      name: $._config.cluster_identity_name,
    },
    location: $._config.location,
    networkSpec: {
      subnets: [
        {
          name: 'control-plane-subnet',
          role: 'control-plane',
        },
        {
          name: 'node-subnet',
          natGateway: {
            name: 'node-natgateway',
          },
          role: 'node',
        },
      ],
      vnet: {
        name: '%s-vnet' % $._config.cluster_name,
      },
    },
    resourceGroup: $._config.resource_group,
    subscriptionID: $._config.subscription_id,
  },
}
