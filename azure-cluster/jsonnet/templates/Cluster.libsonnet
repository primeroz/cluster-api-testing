{
  _config+:: {},

  apiVersion: 'cluster.x-k8s.io/v1beta1',
  kind: 'Cluster',
  metadata: {
    labels: $._config.cluster.labels {
    },
    name: $._config.cluster_name,
    namespace: $._config.namespace,
  },
  spec: {
    clusterNetwork: {
      pods: {
        cidrBlocks: $._config.cluster.podCidrBlocks,
      },
    },
    controlPlaneRef: {
      apiVersion: 'controlplane.cluster.x-k8s.io/v1beta1',
      kind: 'KubeadmControlPlane',
      name: '%s-control-plane' % $._config.cluster_name,
    },
    infrastructureRef: {
      apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
      kind: 'AzureCluster',
      name: $._config.cluster_name,
    },
  },
}