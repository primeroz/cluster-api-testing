include ../env.$(ENVIRONMENT).mk
include ../common.mk


current_dir = $(shell pwd)

CONTEXT_FILE ?= /dev/null
KUBECTL_COMMAND ?= kubectl --kubeconfig=${CONTEXT_FILE}
CILIUM_COMMAND ?= KUBECONFIG=${CONTEXT_FILE} cilium
HELM_COMMAND ?= helm --kubeconfig=${CONTEXT_FILE}

ifeq ($(KUBERNETES_VERSION), 1.23)
  AZUREDISK_CSI_CHART_VERSION := 1.24.0
else ifeq ($(KUBERNETES_VERSION), 1.24)
  AZUREDISK_CSI_CHART_VERSION := 1.24.0
else ifeq ($(KUBERNETES_VERSION), 1.25)
  AZUREDISK_CSI_CHART_VERSION := 1.24.0
endif

.PHONY: host-configurator
host-configurator:
	@${KUBECTL_COMMAND} apply -f host-configurator/host-configurator.yaml

.PHONY: storage
storage:
	@${KUBECTL_COMMAND} apply -f storage/storageclass-managed-csi.yaml

.PHONY: calico
calico:
	@${KUBECTL_COMMAND} apply -f https://raw.githubusercontent.com/kubernetes-sigs/cluster-api-provider-azure/main/templates/addons/calico.yaml

.PHONY: cilium
cilium:
	@${CILIUM_COMMAND} cilium install --helm-set "ipam.operator.clusterPoolIPv4PodCIDR=$(KUBERNETES_PODS_CIDR_BLOCK),ipam.operator.clusterPoolIPv4MaskSize=27"
	@${CILIUM_COMMAND} cilium status

.PHONY: azuredisk-csi
azuredisk-csi:
	@${HELM_COMMAND} install azuredisk-csi azuredisk-csi-driver/azuredisk-csi-driver --version v${AZUREDISK_CSI_CHART_VERSION} --namespace kube-system --set cloud=AzurePublicCloud --set snapshot.enabled=true --set windows.enabled=false --set controller.runOnControlPlane=true 

.PHONY: azure-workload-identity
azure-workload-identity:
	@${HELM_COMMAND} install workload-identity-webhook azure-workload-identity/workload-identity-webhook \
   --namespace azure-workload-identity-system \
   --create-namespace \
   --set azureTenantID="$(AZURE_TENANT_ID)"

.PHONY: deploy
deploy: calico storage azuredisk-csi azure-workload-identity

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
