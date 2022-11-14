local cluster = import 'cluster.libsonnet';
local azure_cluster = import 'templates/AzureCluster.libsonnet';
local azure_machine_template_control_plane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local azure_machine_template_nodes = import 'templates/AzureMachineTemplate-nodes.libsonnet';
local kubeadm_control_plane = import 'templates/KubeadmControlPlane-control-plane.libsonnet';


cluster {

  _config+:: {
    cluster_name: 'test4',
    namespace: 'aks',
    location: 'westeurope',
    sshPublicKey: std.base64(importstr '/tmp/id_rsa.pub'),  // only works with rsa key ???

    azure_client_id:: std.extVar('AZURE_CLIENT_ID'),
    azure_tenant_id:: std.extVar('AZURE_TENANT_ID'),
    resource_group:: std.extVar('AZURE_RESOURCE_GROUP'),
    subscription_id:: std.extVar('AZURE_SUBSCRIPTION'),
    cluster_identity_secret_name:: std.extVar('AZURE_CLUSTER_IDENTITY_SECRET_NAME'),
    user_assigned_identity_provider_id:: '/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ManagedIdentity/userAssignedIdentities/%s' % [$._config.subscription_id, $._config.resource_group, $._config.cluster_name],

    management_network_name:: 'managementVnet',

    controlplane+: {
      replicas: 1,
    },

    nodes+: {
      replicas: 1,
    },

    cluster+: {
      service_account_issuer:: 'https://%s.blob.core.windows.net/%s/' % ['oidcissuer1f6ede0f', $._config.cluster_name],
      podsCidrBlocks:: [std.extVar('KUBERNETES_PODS_CIDR_BLOCK')],
      servicesCidrBlocks:: [std.extVar('KUBERNETES_SERVICES_CIDR_BLOCK')],
    },
  },

  azureCluster+:
    azure_cluster.mixins.patchPrivateCluster +
    azure_cluster.mixins.patchNetworkPeering($._config.resource_group, $._config.management_network_name),

  controlPlane+: {
    azureMachineTemplate+:
      azure_machine_template_control_plane.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id),
    //azure_machine_template_control_plane.mixins.patchSetSpot, // not enough quota for more than 3 cpu on spot for now

    kubeadmControl+:
      kubeadm_control_plane.mixins.patchPrivateCluster($._config.cluster_name),
  },

  nodesDeployments+: {
    template+:: {
      azureMachineTemplate+:
        azure_machine_template_nodes.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id) +
        azure_machine_template_control_plane.mixins.patchPrivateCluster,
      //azure_machine_template_control_plane.mixins.patchSetSpot,

      machineDeployment+: {
        metadata+: {
          annotations+: {
            'cluster.x-k8s.io/cluster-api-autoscaler-node-group-min-size': '1',
            'cluster.x-k8s.io/cluster-api-autoscaler-node-group-max-size': '3',
          },
        },
      },
    },

    // Only deploy one machineDeployment
    Nodes2:: null,
    Nodes3:: null,
  },

}
