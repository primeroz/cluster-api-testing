local cluster = import 'cluster.libsonnet';
local azure_machine_template_control_plane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local azure_machine_template_nodes = import 'templates/AzureMachineTemplate-nodes.libsonnet';


cluster {

  _config+:: {
    cluster_name: 'test3',
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

    nodes+: {
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
    //azure_machine_template_control_plane.mixins.patchSetSpot, // not enough quota for more than 3 cpu on spot for now
  },

  nodesDeployments+: {
    template+:: {
      azureMachineTemplate+:
        azure_machine_template_nodes.mixins.patchUserAssignedIdentity($._config.user_assigned_identity_provider_id),
      //azure_machine_template_control_plane.mixins.patchSetSpot,
    },

    // Only deploy one machineDeployment
    Nodes2:: null,
    Nodes3:: null,
  },

}
