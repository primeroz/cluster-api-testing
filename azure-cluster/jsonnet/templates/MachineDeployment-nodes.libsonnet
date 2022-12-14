{
  _config+:: {
    nodes+: {
      instance: error 'instance for this nodepool must be specified',
      failureDomain: null,
      paused: false,
      minReadySeconds: 30,
    },
  },

  apiVersion: 'cluster.x-k8s.io/v1beta1',
  kind: 'MachineDeployment',
  metadata: {
    name: '%s-md-%s' % [$._config.cluster_name, $._config.nodes.instance],
    namespace: $._config.namespace,
  },
  spec: {
    paused: $._config.nodes.paused,
    clusterName: $._config.cluster_name,
    replicas: $._config.nodes.replicas,
    minReadySeconds: $._config.nodes.minReadySeconds,
    selector: {
      matchLabels: null,
    },
    template: {
      metadata: {
        labels: {
          owner: 'team-fake',
        },
      },
      spec: {
        bootstrap: {
          configRef: {
            apiVersion: 'bootstrap.cluster.x-k8s.io/v1beta1',
            kind: 'KubeadmConfigTemplate',
            name: '%s-md-%s' % [$._config.cluster_name, $._config.nodes.instance],
          },
        },
        clusterName: $._config.cluster_name,
        infrastructureRef: {
          apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
          kind: 'AzureMachineTemplate',
          name: '%s-md-%s' % [$._config.cluster_name, $._config.nodes.instance],
        },
        version: $._config.cluster.version,
        [if $._config.nodes.failureDomain != null then 'failureDomain']: $._config.nodes.failureDomain,
      },
    },
  },
}
