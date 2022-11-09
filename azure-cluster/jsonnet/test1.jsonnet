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

    azure_client_id:: std.extVar('AZURE_CLIENT_ID'),
    azure_tenant_id:: std.extVar('AZURE_TENANT_ID'),
    resource_group:: std.extVar('AZURE_RESOURCE_GROUP'),
    subscription_id:: std.extVar('AZURE_SUBSCRIPTION'),
    cluster_identity_secret_name:: std.extVar('AZURE_CLUSTER_IDENTITY_SECRET_NAME'),

    cluster+: {
      version: 'v1.23.13',
    },
  },
}
