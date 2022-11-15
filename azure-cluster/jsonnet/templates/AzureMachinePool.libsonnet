{
  _config+:: {
    nodes+:: {
      instance: error 'must pass instance name for this nodes',
    },
  },

  mixins:: {
    patchSetSpot: {
      spec+: {
        template+: {
          spotVMOptions: {},
        },
      },
    },
    patchUserAssignedIdentity(providerID): {
      spec+: {
        identity: 'UserAssigned',
        userAssignedIdentities: [
          { providerID: providerID },
        ],
      },
    },
  },

  apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
  kind: 'AzureMachinePool',
  metadata: {
    name: '%s-mp-%s' % [$._config.cluster_name, $._config.nodes.instance],
    namespace: $._config.namespace,
  },
  spec: {
    additionalTags: {
      clusterName: $._config.cluster_name,
      nodepool: $.metadata.name,
    },
    location: $._config.nodes.location,
    strategy: {
      type: 'RollingUpdate',
      rollingUpdate: {
        maxSurge: '25%',
        maxUnavailable: 1,
        deletePolicy: 'Oldest',
      },
    },
    template: {
      osDisk: {
        cachingType: 'ReadOnly',
        diffDiskSettings: {
          option: 'Local',
        },
        diskSizeGB: $._config.nodes.os.diskSizeGB,
        osType: 'Linux',
      },
      sshPublicKey: $._config.controlplane.sshPublicKey,
      vmSize: $._config.nodes.vmSize,
    },
  },
}
