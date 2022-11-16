{
  _config+:: {},

  mixins:: {
    patchPrivateCluster: {
      spec+: {
        networkSpec+: {
          // Changing settings after creation is not allowed
          controlPlaneOutboundLB: {
            frontendIPsCount: 1,
          },
          // Use Nat Gateway Instead
          nodeOutboundLB: {
            frontendIPsCount: 1,
          },
          apiServerLB: {
            type: 'Internal',
            frontendIPs: [
              {
                name: 'lb-private-ip-frontend',
                privateIP: $._config.cluster.privateApiLbIp,
              },
            ],
          },
        },
      },
    },
    patchNetworkPeering(resourceGroup, networkName): {
      spec+: {
        networkSpec+: {
          vnet+: {
            peerings: [
              {
                resourceGroup: resourceGroup,
                remoteVnetName: networkName,
              },
            ],
          },
        },
      },
    },
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
    [if $._config.cluster.addTags then 'additionalTags']: {
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
          [if $._config.cluster.nodeSubnet != null then 'cidrBlocks']: [
            $._config.cluster.nodeSubnet,
          ],
        } +
        {},  // Not supported in the CRD ? $.mixins.patchSubnetServiceEndpoints,
        {
          name: 'node-subnet',
          [if $._config.cluster.controlPlaneSubnet != null then 'cidrBlocks']: [
            $._config.cluster.controlPlaneSubnet,
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
        [if $._config.cluster.vnetSubnet != null then 'cidrBlocks']: [
          $._config.cluster.vnetSubnet,
        ],
      },
    },
    resourceGroup: $._config.resource_group,
    subscriptionID: $._config.subscription_id,
  },
}
