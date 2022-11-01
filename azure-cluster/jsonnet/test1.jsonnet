local cluster = import 'cluster.libsonnet';

cluster {

  _config+:: {
    cluster_name: 'test1',
    namespace: 'aks',
  },

}
