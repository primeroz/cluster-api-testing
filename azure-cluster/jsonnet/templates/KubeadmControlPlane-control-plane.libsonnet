{
  _config+:: {},

  apiVersion: 'controlplane.cluster.x-k8s.io/v1beta1',
  kind: 'KubeadmControlPlane',
  metadata: {
    name: '%s-control-plane' % $._config.cluster_name,
    namespace: $._config.namespace,
  },
  spec: {
    kubeadmConfigSpec: {
      clusterConfiguration: {
        apiServer: {
          extraArgs: {
            'cloud-config': '/etc/kubernetes/azure.json',
            'cloud-provider': 'azure',
          },
          extraVolumes: [
            {
              hostPath: '/etc/kubernetes/azure.json',
              mountPath: '/etc/kubernetes/azure.json',
              name: 'cloud-config',
              readOnly: true,
            },
          ],
          timeoutForControlPlane: '20m',
        },
        controllerManager: {
          extraArgs: {
            'allocate-node-cidrs': 'false',
            'cloud-config': '/etc/kubernetes/azure.json',
            'cloud-provider': 'azure',
            'cluster-name': $._config.cluster_name,
          },
          extraVolumes: [
            {
              hostPath: '/etc/kubernetes/azure.json',
              mountPath: '/etc/kubernetes/azure.json',
              name: 'cloud-config',
              readOnly: true,
            },
          ],
        },
        etcd: {
          'local': {
            dataDir: '/var/lib/etcddisk/etcd',
            extraArgs: {
              'quota-backend-bytes': '8589934592',
            },
          },
        },
      },
      diskSetup: {
        filesystems: [
          {
            device: '/dev/disk/azure/scsi1/lun0',
            extraOpts: [
              '-E',
              'lazy_itable_init=1,lazy_journal_init=1',
            ],
            filesystem: 'ext4',
            label: 'etcd_disk',
          },
          {
            device: 'ephemeral0.1',
            filesystem: 'ext4',
            label: 'ephemeral0',
            replaceFS: 'ntfs',
          },
        ],
        partitions: [
          {
            device: '/dev/disk/azure/scsi1/lun0',
            layout: true,
            overwrite: false,
            tableType: 'gpt',
          },
        ],
      },
      files: [
        {
          contentFrom: {
            secret: {
              key: 'control-plane-azure.json',
              name: '%s-control-plane-azure-json' % $._config.cluster_name,
            },
          },
          owner: 'root:root',
          path: '/etc/kubernetes/azure.json',
          permissions: '0644',
        },
      ],
      initConfiguration: {
        nodeRegistration: {
          kubeletExtraArgs: {
            'azure-container-registry-config': '/etc/kubernetes/azure.json',
            'cloud-config': '/etc/kubernetes/azure.json',
            'cloud-provider': 'azure',
          },
          name: '{{ ds.meta_data["local_hostname"] }}',
        },
      },
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
      mounts: [
        [
          'LABEL=etcd_disk',
          '/var/lib/etcddisk',
        ],
      ],
      postKubeadmCommands: [],
      preKubeadmCommands: [],
    },
    machineTemplate: {
      infrastructureRef: {
        apiVersion: 'infrastructure.cluster.x-k8s.io/v1beta1',
        kind: 'AzureMachineTemplate',
        name: '%s-control-plane' % $._config.cluster_name,
      },
    },
    replicas: $._config.controlplane.replicas,
    version: $._config.cluster.version,
  },
}