local cluster = import 'cluster.libsonnet';
local azure_machine_template_control_plane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local azure_machine_template_nodes = import 'templates/AzureMachineTemplate-nodes.libsonnet';


cluster {

  _config+:: {
    cluster_name: 'test2-ua',
    namespace: 'aks',
    location: 'westeurope',
    sshPublicKey: std.base64(importstr '/home/fciocchetti/.ssh/id_rsa.pub'),  // only works with rsa key ???

    azure_client_id:: std.extVar('AZURE_CLIENT_ID'),
    azure_tenant_id:: std.extVar('AZURE_TENANT_ID'),
    resource_group:: std.extVar('AZURE_RESOURCE_GROUP'),
    subscription_id:: std.extVar('AZURE_SUBSCRIPTION'),
    cluster_identity_secret_name:: std.extVar('AZURE_CLUSTER_IDENTITY_SECRET_NAME'),
    user_assigned_identity_provider_id:: '/subscriptions/%s/resourceGroups/%s/providers/Microsoft.ManagedIdentity/userAssignedIdentities/%s' % [$._config.subscription_id, $._config.resource_group, $._config.cluster_name],

    cluster+: {
      version: 'v1.23.13',
    },
  },

  controlPlane+: {
    azureMachineTemplate+: azure_machine_template_control_plane.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id),
  },

  nodesDeployments+: {
    azureMachineTemplate+: azure_machine_template_nodes.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id),
  },

}
