local cluster = import 'cluster.libsonnet';
local azure_machine_pool = import 'templates/AzureMachinePool.libsonnet';
local kubeadm_config = import 'templates/KubeadmConfig-pool.libsonnet';
local machine_pool = import 'templates/MachinePool.libsonnet';


cluster {

  _config+:: {
    cluster_name: 'test1',
    namespace: 'aks',
    location: 'westeurope',
    //sshPublicKey: std.base64(importstr '/home/fciocchetti/.ssh/id_ed25519.pub'),
    sshPublicKey: std.base64(importstr '/home/fciocchetti/.ssh/id_rsa.pub'),  // only works with rsa key ???

    cluster+: {
      version: 'v1.23.13',
    },
  },

  // Need MachinePool FeatureFlag
  azureMachinePool0:: azure_machine_pool {
    _config+:: $._config {
      nodes+: {
        location: $._config.location,
        instance: '0',
      },
    },
  },

  machinePool0:: machine_pool {
    _config+:: $._config {
      nodes+: {
        instance: '0',
      },
    },
  },

  kubeadmConfigPool0:: kubeadm_config {
                         _config+:: $._config {
                           nodes+: {
                             instance: '0',
                           },
                         },
                       } +
                       // Default to use external cloud provider
                       kubeadm_config.mixins.patchExternalCloudProvider,


}
