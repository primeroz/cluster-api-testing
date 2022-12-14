include ../env.$(ENVIRONMENT).mk
include ../common.mk


current_dir = $(shell pwd)

KUBECFG_COMMAND ?= show

.PHONY: prep
prep:
	@kubectl get ns $(CLUSTER_NAMESPACE) >/dev/null 2>&1 || kubectl create namespace $(CLUSTER_NAMESPACE) >/dev/null
	@kubectl get secret -n $(AZURE_CLUSTER_IDENTITY_SECRET_NAMESPACE) $(AZURE_CLUSTER_IDENTITY_SECRET_NAME) >/dev/null 2>&1 || kubectl create secret -n $(AZURE_CLUSTER_IDENTITY_SECRET_NAMESPACE) generic "$(AZURE_CLUSTER_IDENTITY_SECRET_NAME)" --from-literal=clientSecret="$(AZURE_CLIENT_SECRET)" >/dev/null
	@kubectl label secret -n $(AZURE_CLUSTER_IDENTITY_SECRET_NAMESPACE) "$(AZURE_CLUSTER_IDENTITY_SECRET_NAME)" "clusterctl.cluster.x-k8s.io/move-hierarchy=true" --overwrite=true

.PHONY: generate
generate: prep
	@kubecfg ${KUBECFG_COMMAND} jsonnet/${CLUSTER_NAME}.jsonnet \
    --ext-str="AZURE_SUBSCRIPTION" \
    --ext-str="AZURE_TENANT_ID" \
    --ext-str="AZURE_CLIENT_ID" \
    --ext-str="AZURE_CLUSTER_IDENTITY_SECRET_NAME=$(AZURE_CLUSTER_IDENTITY_SECRET_NAME)" \
    --ext-str="KUBERNETES_VERSION=$(KUBERNETES_VERSION)" \
    --ext-str="KUBERNETES_PODS_CIDR_BLOCK=$(KUBERNETES_PODS_CIDR_BLOCK)" \
    --ext-str="KUBERNETES_SERVICES_CIDR_BLOCK=$(KUBERNETES_SERVICES_CIDR_BLOCK)" \
    --ext-str="AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP}"

.PHONY: deploy
deploy: generate

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
