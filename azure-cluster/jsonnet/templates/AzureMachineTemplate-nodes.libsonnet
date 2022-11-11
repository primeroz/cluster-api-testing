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
          spec+: {
            spotVMOptions: {},
          },
        },
      },
    },
    patchUserAssignedIdentity(providerID): {
      spec+: {
        template+: {
          spec+: {
            identity: 'UserAssigned',
            userAssignedIdentities: [
              { providerID: providerID },
            ],
          },
        },
      },
    },
  },

  apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
  kind: 'AzureMachineTemplate',
  metadata: {
    name: '%s-md-%s' % [$._config.cluster_name, $._config.nodes.instance],
    namespace: $._config.namespace,
  },
  spec: {
    template: {
      spec: {
        additionalTags: {
          clusterName: $._config.cluster_name,
          nodepool: $.metadata.name,
        },
        osDisk: {
          cachingType: 'ReadOnly',
          diffDiskSettings: {
            option: 'Local',
          },
          diskSizeGB: $._config.nodes.os.diskSizeGB,
          osType: 'Linux',
          managedDisk: {
            storageAccountType: 'Standard_LRS',
          },
        },
        sshPublicKey: $._config.controlplane.sshPublicKey,
        vmSize: $._config.nodes.vmSize,
      },
    },
  },
}
