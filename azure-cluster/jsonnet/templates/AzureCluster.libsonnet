{
  _config+:: {},

  mixins:: {
    patchSubnetServiceEndpoints: {
      serviceEndpoints: [
        {
          service: 'Microsoft.AzureActiveDirectory',
          locations: ['*'],
        },
        {
          service: 'Microsoft.Storage',
          locations: [$._config.location],
        },
      ],
    },
  },

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
    additionalTags: {
      clusterName: $._config.cluster_name,
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
          cidrBlocks: [
            '10.0.0.0/24',
          ],
        } +
        {},  // Not supported in the CRD ? $.mixins.patchSubnetServiceEndpoints,
        {
          name: 'node-subnet',
          cidrBlocks: [
            '10.1.0.0/16',
          ],
          natGateway: {
            name: 'node-natgateway',
          },
          role: 'node',
        } +
        {},  // Not supported in the CRD ? $.mixins.patchSubnetServiceEndpoints,
      ],
      vnet: {
              name: '%s-vnet' % $._config.cluster_name,
              cidrBlocks: [
                '10.0.0.0/8',
              ],
            } +
            (
              if std.get($._config, 'management_vnet', null) != null then
                {
                  peerings: [
                    {
                      resourceGroup: $._config.resource_group,
                      remoteVnetName: $._config.management_vnet,
                    },
                  ],
                }
              else {}
            ),
      [if $._config.cluster.type == 'private' then 'apiServerLB']: {
        type: 'Internal',
        frontendIPs: [
          {
            name: 'lb-private-ip-frontend',
            privateIP: '10.0.0.100',
          },
        ],
      },
    },
    resourceGroup: $._config.resource_group,
    subscriptionID: $._config.subscription_id,
  },
}
