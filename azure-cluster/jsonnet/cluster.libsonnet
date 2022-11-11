local config = import 'config.libsonnet';
local azure_cluster = import 'templates/AzureCluster.libsonnet';
local azure_cluster_identity = import 'templates/AzureClusterIdentity.libsonnet';
local azure_machine_template_controlplane = import 'templates/AzureMachineTemplate-control-plane.libsonnet';
local azure_machine_template_nodes = import 'templates/AzureMachineTemplate-nodes.libsonnet';
local cluster = import 'templates/Cluster.libsonnet';
local kubeadm_config_template_nodes = import 'templates/KubeadmConfigTemplate-nodes.libsonnet';
local kubeadm_control_plane = import 'templates/KubeadmControlPlane-control-plane.libsonnet';
local machine_deployment = import 'templates/MachineDeployment-nodes.libsonnet';
local machine_healthcheck = import 'templates/MachineHealthCheck.libsonnet';

config {

  _config+:: {
    cluster_name:: error 'cluster_name is required',
    namespace:: error 'namespace is required',
    location:: 'westeurope',
    resource_group:: 'testClusterAPI',

    cluster+: {
      kubernetes_versions_map: {
        '1.23': '1.23.13',
        '1.24': '1.24.7',
        '1.25': '1.25.3',
      },

      bastion:: false,
      version: 'v%s' % $._config.cluster.kubernetes_versions_map[std.extVar('KUBERNETES_VERSION')],
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

    machineHealthCheck: machine_healthcheck {
      _config+:: $._config {
        nodes+: {
          instance: 'control-plane',
        },
      },

      spec+: {
        maxUnhealthy: '100%',
        nodeStartupTimeout:: null,
        selector: {
          matchLabels: {
            'cluster.x-k8s.io/control-plane': '',
          },
        },
      },
    },
  },

  // Nodes
  nodesDeployments: {
    local nodes = self,

    template:: {
      local template = self,
      instance:: null,
      failureDomain:: null,

      azureMachineTemplate: azure_machine_template_nodes {
        _config+:: $._config {
          nodes+: {
            instance: template.instance,
          },
        },
      },

      kubeadmConfig: kubeadm_config_template_nodes {
                       _config+:: $._config {
                         nodes+: {
                           instance: template.instance,
                         },
                       },
                     } +
                     // Default to use external cloud provider
                     kubeadm_config_template_nodes.mixins.patchExternalCloudProvider,

      machineDeployment: machine_deployment {
        _config+:: $._config {
          nodes+: {
            instance: template.instance,
            failureDomain: template.failureDomain,
          },
        },
      },

      machineHealthCheck: machine_healthcheck {
        _config+:: $._config {
          nodes+: {
            instance: template.instance,
            failureDomain: template.failureDomain,
          },
        },
      },


    },


    Nodes1: nodes.template {
      instance: '1',
      failureDomain: '1',
    },

    Nodes2: nodes.template {
      instance: '2',
      failureDomain: '2',
    },

    Nodes3: nodes.template {
      instance: '3',
      failureDomain: '3',
    },
  },

}
