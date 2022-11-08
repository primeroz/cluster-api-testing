local config = import 'config.libsonnet';
local azure_cluster = import 'templates/AzureCluster.libsonnet';
local azure_cluster_identity = import 'templates/AzureClusterIdentity.libsonnet';
local azure_machine_template_controlplane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local azure_machine_template_nodes = import 'templates/AzureMachineTemplate-nodes.libsonnet';
local cluster = import 'templates/Cluster.libsonnet';
local kubeadm_config_template_nodes = import 'templates/KubeadmConfigTemplate-nodes.libsonnet';
local kubeadm_config_template_controlplane = import 'templates/KubeadmControlPlane-control-plane.libsonnet';
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
  azureMachineTemplateControlPlane: azure_machine_template_controlplane {
    _config+:: $._config,
  },

  kubeadmControlPlane: kubeadm_config_template_controlplane {
    _config+:: $._config,
  },

  // NodePools
  azureMachineTemplateNodes1: azure_machine_template_nodes {
    _config+:: $._config {
      nodes+: {
        instance: '1',
      },
    },
  },

  azureMachineTemplateNodes2: azure_machine_template_nodes {
    _config+:: $._config {
      nodes+: {
        instance: '2',
      },
    },
  },

  azureMachineTemplateNodes3: azure_machine_template_nodes {
    _config+:: $._config {
      nodes+: {
        instance: '3',
      },
    },
  },

  kubeadmNodes1: kubeadm_config_template_nodes {
    _config+:: $._config {
      nodes+: {
        instance: '1',
      },
    },
  },

  kubeadmNodes2: kubeadm_config_template_nodes {
    _config+:: $._config {
      nodes+: {
        instance: '2',
      },
    },
  },

  kubeadmNodes3: kubeadm_config_template_nodes {
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


}
