{
  _config:: {
    cluster_name: std.extVar('CLUSTER_NAME'),
  },


  serviceAccount: {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      labels: {
        'app.kubernetes.io/name': 'clusterapi-cluster-autoscaler',
        'helm.sh/chart': 'cluster-autoscaler-9.21.0',
      },
      name: 'clusterapi-cluster-autoscaler',
      namespace: 'kube-system',
    },
    automountServiceAccountToken: true,
  },

  serviceAccountSecret: {
    apiVersion: 'v1',
    kind: 'Secret',
    metadata: {
      annotations: {
        'kubernetes.io/service-account.name': 'clusterapi-cluster-autoscaler',
      },
      labels: {
        'app.kubernetes.io/name': 'clusterapi-cluster-autoscaler',
        'helm.sh/chart': 'cluster-autoscaler-9.21.0',
      },
      name: 'clusterapi-cluster-autoscaler',
      namespace: 'kube-system',
    },
    type: 'kubernetes.io/service-account-token',
  },

  clusterRole: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRole',
    metadata: {
      labels: {
        'app.kubernetes.io/name': 'clusterapi-cluster-autoscaler',
        'helm.sh/chart': 'cluster-autoscaler-9.21.0',
      },
      name: 'clusterapi-cluster-autoscaler',
    },
    rules: [
      {
        apiGroups: [
          '',
        ],
        resources: [
          'events',
          'endpoints',
        ],
        verbs: [
          'create',
          'patch',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods/eviction',
        ],
        verbs: [
          'create',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'pods/status',
        ],
        verbs: [
          'update',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'endpoints',
        ],
        resourceNames: [
          'cluster-autoscaler',
        ],
        verbs: [
          'get',
          'update',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'nodes',
        ],
        verbs: [
          'watch',
          'list',
          'get',
          'update',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'namespaces',
          'pods',
          'services',
          'replicationcontrollers',
          'persistentvolumeclaims',
          'persistentvolumes',
        ],
        verbs: [
          'watch',
          'list',
          'get',
        ],
      },
      {
        apiGroups: [
          'batch',
        ],
        resources: [
          'jobs',
          'cronjobs',
        ],
        verbs: [
          'watch',
          'list',
          'get',
        ],
      },
      {
        apiGroups: [
          'batch',
          'extensions',
        ],
        resources: [
          'jobs',
        ],
        verbs: [
          'get',
          'list',
          'patch',
          'watch',
        ],
      },
      {
        apiGroups: [
          'extensions',
        ],
        resources: [
          'replicasets',
          'daemonsets',
        ],
        verbs: [
          'watch',
          'list',
          'get',
        ],
      },
      {
        apiGroups: [
          'policy',
        ],
        resources: [
          'poddisruptionbudgets',
        ],
        verbs: [
          'watch',
          'list',
        ],
      },
      {
        apiGroups: [
          'apps',
        ],
        resources: [
          'daemonsets',
          'replicasets',
          'statefulsets',
        ],
        verbs: [
          'watch',
          'list',
          'get',
        ],
      },
      {
        apiGroups: [
          'storage.k8s.io',
        ],
        resources: [
          'storageclasses',
          'csinodes',
          'csidrivers',
          'csistoragecapacities',
        ],
        verbs: [
          'watch',
          'list',
          'get',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        resourceNames: [
          'cluster-autoscaler-status',
        ],
        verbs: [
          'get',
          'create',
          'delete',
          'update',
        ],
      },
      {
        apiGroups: [
          '',
        ],
        resources: [
          'configmaps',
        ],
        verbs: [
          'create',
          'list',
          'watch',
        ],
      },
      {
        apiGroups: [
          'coordination.k8s.io',
        ],
        resources: [
          'leases',
        ],
        verbs: [
          'create',
        ],
      },
      {
        apiGroups: [
          'coordination.k8s.io',
        ],
        resourceNames: [
          'cluster-autoscaler',
        ],
        resources: [
          'leases',
        ],
        verbs: [
          'get',
          'update',
        ],
      },
    ],
  },

  clusterRoleBinding: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      labels: {
        'app.kubernetes.io/name': 'clusterapi-cluster-autoscaler',
        'helm.sh/chart': 'cluster-autoscaler-9.21.0',
      },
      name: 'clusterapi-cluster-autoscaler',
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: 'clusterapi-cluster-autoscaler',
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: 'clusterapi-cluster-autoscaler',
        namespace: 'kube-system',
      },
    ],
  },
}
