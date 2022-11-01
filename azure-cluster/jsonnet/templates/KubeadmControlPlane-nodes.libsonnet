{
  _config+:: {
    nodes+:: {
      instance: error 'instance for this nodepool must be specified',
    },
  },

  apiVersion: 'bootstrap.cluster.x-k8s.io/v1beta1',
  kind: 'KubeadmConfigTemplate',
  metadata: {
    name: '%s-md-%s' % [$._config.cluster_name, $._config.nodes.instance],
    namespace: $._config.namespace,
  },
  spec: {
    template: {
      spec: {
        files: [
          {
            contentFrom: {
              secret: {
                key: 'worker-node-azure.json',
                name: '%s-md-%s-azure-json' % [$._config.cluster_name, $._config.nodes.instance],
              },
            },
            owner: 'root:root',
            path: '/etc/kubernetes/azure.json',
            permissions: '0644',
          },
        ],
        joinConfiguration: {
          nodeRegistration: {
            kubeletExtraArgs: {
              'azure-container-registry-config': '/etc/kubernetes/azure.json',
              'cloud-config': '/etc/kubernetes/azure.json',
              'cloud-provider': 'azure',
            },
            name: '{{ ds.meta_data["local_hostname"] }}',
          },
        },
        preKubeadmCommands: [],
      },
    },
  },
}
