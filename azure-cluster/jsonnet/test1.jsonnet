local cluster = import 'cluster.libsonnet';

cluster {

  _config+:: {
    cluster_name: 'test1',
    namespace: 'aks',

    cluster+: {
      version: 'v1.23.13',
    },
  },

}
