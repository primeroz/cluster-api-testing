{
  _config+:: {
    nodes+: {
      instance: error 'instance for this nodepool must be specified',
      failureDomains: [
        '1',
        '2',
        '3',
      ],
    },
  },

  apiVersion: 'cluster.x-k8s.io/v1beta1',
  kind: 'MachinePool',
  metadata: {
    name: '%s-mp-%s' % [$._config.cluster_name, $._config.nodes.instance],
    namespace: $._config.namespace,
  },
  spec: {
    clusterName: $._config.cluster_name,
    [if std.length($._config.nodes.failureDomains) > 0 then 'failureDomains']: $._config.nodes.failureDomains,
    replicas: $._config.nodes.replicas,
    template: {
      spec: {
        bootstrap: {
          configRef: {
            apiVersion: 'bootstrap.cluster.x-k8s.io/v1beta1',
            kind: 'KubeadmConfig',
            name: '%s-mp-%s' % [$._config.cluster_name, $._config.nodes.instance],
          },
        },
        clusterName: $._config.cluster_name,
        infrastructureRef: {
          apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
          kind: 'AzureMachinePool',
          name: '%s-mp-%s' % [$._config.cluster_name, $._config.nodes.instance],
        },
        version: $._config.cluster.version,
      },
    },
  },
}
