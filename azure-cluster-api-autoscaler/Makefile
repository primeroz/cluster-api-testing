include ../env.$(ENVIRONMENT).mk
include ../common.mk


current_dir = $(shell pwd)

CONTEXT_FILE ?= /dev/null
WORKLOAD_KUBECTL_COMMAND ?= kubectl --kubeconfig=${CONTEXT_FILE}
WORKLOAD_KUBECFG_COMMAND ?= kubecfg --kubeconfig=${CONTEXT_FILE}
WORKLOAD_HELM_COMMAND ?= helm --kubeconfig=${CONTEXT_FILE}

ifeq ($(KUBERNETES_VERSION), 1.23)
  CLUSTER_AUTOSCALER_VERSION := 1.23.0
else ifeq ($(KUBERNETES_VERSION), 1.24)
  CLUSTER_AUTOSCALER_VERSION := 1.24.0
else ifeq ($(KUBERNETES_VERSION), 1.25)
  CLUSTER_AUTOSCALER_VERSION := 1.25.0
endif

define WORKLOAD_KUBECONFIG
apiVersion: v1
kind: Config
clusters:
- name: $(CLUSTER_NAME)
  cluster:
    certificate-authority-data: ${CA}
    server: ${SERVER_URL}
contexts:
- name: $(CLUSTER_NAME)
  context:
    cluster: $(CLUSTER_NAME)
    namespace: kube-system
    user: $(CLUSTER_NAME)
current-context: $(CLUSTER_NAME)
users:
- name: $(CLUSTER_NAME)
  user:
    token: ${TOKEN}
endef
export WORKLOAD_KUBECONFIG 


.PHONY: workload-cluster
workload-cluster:
	@${WORKLOAD_KUBECFG_COMMAND} update workload-cluster/rbac.jsonnet \
    --ext-str="CLUSTER_NAME=$(CLUSTER_NAME)"

.PHONY: generate-kubeconfig
generate-kubeconfig:
	@$(eval SERVER_URL = $(shell clusterctl get kubeconfig $(CLUSTER_NAME) | yq '.clusters[0].cluster.server' -r ))
	@$(eval CA = $(shell clusterctl get kubeconfig $(CLUSTER_NAME) | yq '.clusters[0].cluster."certificate-authority-data"' -r ))
	@$(eval TOKEN = $(shell $(WORKLOAD_KUBECTL_COMMAND) get -n kube-system secret/clusterapi-cluster-autoscaler -o jsonpath='{.data.token}' | base64 -d ))

	@echo "$$WORKLOAD_KUBECONFIG" | cat > /tmp/kubeconfig-cluster-autoscaler-$(CLUSTER_NAME)
	@kubectl get secret -n $(CLUSTER_NAMESPACE) kubeconfig-cluster-autoscaler-$(CLUSTER_NAME) || kubectl --context=$(KUBE_CONTEXT) create secret -n $(CLUSTER_NAMESPACE) generic kubeconfig-cluster-autoscaler-$(CLUSTER_NAME) --from-file=value=/tmp/kubeconfig-cluster-autoscaler-$(CLUSTER_NAME)
	#@rm -f /tmp/kubeconfig-cluster-autoscaler-$(CLUSTER_NAME)


.PHONY: azure-cluster-api
# MGMT in cluster
# REMOTE kubeconfig
azure-cluster-api:
	@helm upgrade -i $(CLUSTER_NAME) autoscaler/cluster-autoscaler --version=9.21.0 --namespace $(CLUSTER_NAMESPACE) \
    --set cloudProvider=clusterapi \
    --set autoDiscovery.clusterName=$(CLUSTER_NAME) \
    --set autoDiscovery.labels[0].namespace=$(CLUSTER_NAMESPACE) \
    --set clusterAPIMode=kubeconfig-incluster \
    --set clusterAPIKubeconfigSecret=kubeconfig-cluster-autoscaler-$(CLUSTER_NAME) \
    --set clusterAPIConfigMapsNamespace="kube-system" \
    --set extraArgs.status-config-map-name=cluster-autoscaler-status \
    --set extraArgs.v=4 \
    --set extraArgs.cluster-name=$(CLUSTER_NAME) \
    --set image.tag=v$(CLUSTER_AUTOSCALER_VERSION) \
    --set rbac.clusterScoped=false

.PHONY: deploy
deploy: workload-cluster generate-kubeconfig azure-cluster-api

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
