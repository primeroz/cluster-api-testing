{
  _config+:: {},

  mixins:: {
    patchSetSpot: {
      spec+: {
        spotVMOptions: {},
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
    name: '%s-control-plane' % $._config.cluster_name,
    namespace: $._config.namespace,
  },
  spec: {
    template: {
      spec: {
        dataDisks: [
          {
            diskSizeGB: $._config.controlplane.etcddisk.sizeGB,
            lun: 0,
            nameSuffix: 'etcddisk',
          },
        ],
        osDisk: {
          cachingType: 'ReadOnly',
          diffDiskSettings: {
            option: 'Local',
          },
          diskSizeGB: $._config.controlplane.os.diskSizeGB,
          osType: 'Linux',
        },
        sshPublicKey: $._config.controlplane.sshPublicKey,
        vmSize: $._config.controlplane.vmSize,
      },
    },
  },
}
