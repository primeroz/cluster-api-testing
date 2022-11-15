local cluster = import 'cluster.libsonnet';
local azure_machine_pool = import 'templates/AzureMachinePool.libsonnet';
local azure_machine_template_control_plane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local kubeadm_config_pool = import 'templates/KubeadmConfig-pool.libsonnet';
local machine_pool = import 'templates/MachinePool.libsonnet';


cluster {

  _config+:: {
    cluster_name: 'test5',
    namespace: 'aks',
    location: 'westeurope',
    sshPublicKey: std.base64(importstr '/home/fciocchetti/.ssh/id_rsa.pub'),  // only works with rsa key ???

    azure_client_id:: std.extVar('AZURE_CLIENT_ID'),
    azure_tenant_id:: std.extVar('AZURE_TENANT_ID'),
    resource_group:: std.extVar('AZURE_RESOURCE_GROUP'),
    subscription_id:: std.extVar('AZURE_SUBSCRIPTION'),
    cluster_identity_secret_name:: std.extVar('AZURE_CLUSTER_IDENTITY_SECRET_NAME'),
    user_assigned_identity_provider_id:: '/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ManagedIdentity/userAssignedIdentities/%s' % [$._config.subscription_id, $._config.resource_group, $._config.cluster_name],

    controlplane+: {
      replicas: 1,
    },

    cluster+: {
      service_account_issuer:: 'https://%s.blob.core.windows.net/%s/' % ['oidcissuer1f6ede0f', $._config.cluster_name],
      podsCidrBlocks:: [std.extVar('KUBERNETES_PODS_CIDR_BLOCK')],
      servicesCidrBlocks:: [std.extVar('KUBERNETES_SERVICES_CIDR_BLOCK')],
    },
  },

  controlPlane+: {
    azureMachineTemplate+:
      azure_machine_template_control_plane.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id),
  },

  nodesDeployments:: null,

  // Need MachinePool FeatureFlag
  azureMachinePool0: azure_machine_pool {
                       _config+:: $._config {
                         nodes+: {
                           location: $._config.location,
                           instance: '0',
                         },
                       },
                     } +
                     //azure_machine_pool.mixins.patchSetSpot + // not enough quota :(
                     azure_machine_pool.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id),

  machinePool0: machine_pool {
    _config+:: $._config {
      nodes+: {
        instance: '0',
        replicas: 2,
      },
    },
  },

  kubeadmConfig0: kubeadm_config_pool {
                    _config+:: $._config {
                      nodes+: {
                        instance: '0',
                      },
                    },
                  } +
                  // Default to use external cloud provider
                  kubeadm_config_pool.mixins.patchExternalCloudProvider,


}
