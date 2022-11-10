{
  _config+:: {
    nodes+: {
      instance: error 'instance for this nodepool must be specified',
      failureDomain: null,
    },
  },

  apiVersion: 'cluster.x-k8s.io/v1beta1',
  kind: 'MachineHealthCheck',
  metadata: {
    name: '%s-md-%s-healthcheck' % [$._config.cluster_name, $._config.nodes.instance],
    namespace: $._config.namespace,
  },
  spec: {
    clusterName: $._config.cluster_name,
    maxUnhealthy: '25%',
    nodeStartupTimeout: '10m',
    selector: {
      matchLabels: {
        'cluster.x-k8s.io/deployment-name': '%s-md-%s' % [$._config.cluster_name, $._config.nodes.instance],
      },
    },
    unhealthyConditions: [
      {
        type: 'Ready',
        status: 'Unknown',
        timeout: '300s',
      },
      {
        type: 'Ready',
        status: 'False',
        timeout: '300s',
      },
    ],
  },
}
