{
  _config+:: {
    nodes+:: {
      instance: error 'must pass instance name for this nodes',
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
        osDisk: {
          cachingType: 'ReadOnly',
          diffDiskSettings: {
            option: 'Local',
          },
          diskSizeGB: $._config.nodes.os.diskSizeGB,
          osType: 'Linux',
        },
        sshPublicKey: '',
        vmSize: $._config.nodes.vmSize,
      },
    },
  },
}
