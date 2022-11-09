local config = import 'config.libsonnet';
local azure_cluster = import 'templates/AzureCluster.libsonnet';
local azure_cluster_identity = import 'templates/AzureClusterIdentity.libsonnet';
local azure_machine_template_controlplane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local azure_machine_template_nodes = import 'templates/AzureMachineTemplate-nodes.libsonnet';
local cluster = import 'templates/Cluster.libsonnet';
local kubeadm_config_template_nodes = import 'templates/KubeadmConfigTemplate-nodes.libsonnet';
local kubeadm_control_plane = import 'templates/KubeadmControlPlane-control-plane.libsonnet';
local machine_deployment = import 'templates/MachineDeployment-nodes.libsonnet';

config {

  _config+:: {
    cluster_name:: error 'cluster_name is required',
    namespace:: error 'namespace is required',
    location:: 'westeurope',
    resource_group:: 'testClusterAPI',

    cluster+: {
      bastion:: false,
      version: error 'cluster version is required',
    },
  },

  // Cluster Resources
  cluster: cluster {
    _config+:: $._config,
  },

  azureCluster: azure_cluster {
    _config+:: $._config,
  },

  azureClusterIdentity: azure_cluster_identity {
    _config+:: $._config,
  },

  // ControlPlane Resources
  controlPlane: {
    azureMachineTemplate: azure_machine_template_controlplane {
      _config+:: $._config,
    },

    kubeadmControl: kubeadm_control_plane {
                      _config+:: $._config,
                    } +
                    // Default to use external cloud provider
                    kubeadm_control_plane.mixins.patchExternalCloudProvider,
  },

  // Nodes
  nodesDeployments: {
    local nodes = self,

    azureMachineTemplate:: azure_machine_template_nodes {},

    azureMachineTemplateNodes1: nodes.azureMachineTemplate {
      _config+:: $._config {
        nodes+: {
          instance: '1',
        },
      },
    },

    azureMachineTemplateNodes2: nodes.azureMachineTemplate {
      _config+:: $._config {
        nodes+: {
          instance: '2',
        },
      },
    },

    azureMachineTemplateNodes3: nodes.azureMachineTemplate {
      _config+:: $._config {
        nodes+: {
          instance: '3',
        },
      },
    },

    kubeadmConfig:: kubeadm_config_template_nodes {
                    } +
                    // Default to use external cloud provider
                    kubeadm_config_template_nodes.mixins.patchExternalCloudProvider,

    kubeadmNodes1: nodes.kubeadmConfig {
      _config+:: $._config {
        nodes+: {
          instance: '1',
        },
      },
    },

    kubeadmNodes2: nodes.kubeadmConfig {
      _config+:: $._config {
        nodes+: {
          instance: '2',
        },
      },
    },

    kubeadmNodes3: nodes.kubeadmConfig {
      _config+:: $._config {
        nodes+: {
          instance: '3',
        },
      },
    },

    machineDeployment1: machine_deployment {
      _config+:: $._config {
        nodes+: {
          instance: '1',
          failureDomain: '1',
        },
      },
    },

    machineDeployment2: machine_deployment {
      _config+:: $._config {
        nodes+: {
          instance: '2',
          failureDomain: '2',
        },
      },
    },

    machineDeployment3: machine_deployment {
      _config+:: $._config {
        nodes+: {
          instance: '3',
          failureDomain: '3',
        },
      },
    },
  },

}
