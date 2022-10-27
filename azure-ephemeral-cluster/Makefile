include ../env.$(ENVIRONMENT).mk
include ../env.base-cluster.mk
include ../common.mk

.PHONY: prep
prep:
	@kubectl get ns aks >/dev/null 2>&1 || kubectl create namespace aks >/dev/null
	@kubectl get secret ${AZURE_CLUSTER_IDENTITY_SECRET_NAME} >/dev/null 2>&1 || kubectl create secret generic "${AZURE_CLUSTER_IDENTITY_SECRET_NAME}" --from-literal=clientSecret="${AZURE_CLIENT_SECRET}" >/dev/null
	@kubectl label secret "${AZURE_CLUSTER_IDENTITY_SECRET_NAME}" "clusterctl.cluster.x-k8s.io/move-hierarchy=true" --overwrite=true

.PHONY: generate
generate: prep
	@clusterctl generate cluster ${CLUSTER_NAME} --kubernetes-version ${KUBERNETES_VERSION} --infrastructure azure --target-namespace=${CLUSTER_NAMESPACE} --flavor ephemeral > /dev/shm/cluster.yaml

.PHONY: deploy
deploy: generate

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
