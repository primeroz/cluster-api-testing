include ../env.$(ENVIRONMENT).mk
include ../common.mk


current_dir = $(shell pwd)

CONTEXT_FILE ?= /dev/null
KUBECTL_COMMAND ?= kubectl --kubeconfig=${CONTEXT_FILE}
HELM_COMMAND ?= helm --kubeconfig=${CONTEXT_FILE}

CLOUD_PROVIDER_AZURE_CIDR ?= 192.168.0.0/16
CLOUD_PROVIDER_AZURE_CREATE_ROUTES ?= false

ifeq ($(KUBERNETES_VERSION), 1.23)
  CLOUD_PROVIDER_AZURE_CHART_VERSION := 1.23.11
  CLOUD_PROVIDER_AZURE_IMAGE_VERSION := 1.23.23
else ifeq ($(KUBERNETES_VERSION), 1.24)
  CLOUD_PROVIDER_AZURE_CHART_VERSION := 1.24.5
  CLOUD_PROVIDER_AZURE_IMAGE_VERSION := 1.24.10
else ifeq ($(KUBERNETES_VERSION), 1.25)
  CLOUD_PROVIDER_AZURE_CHART_VERSION := 1.25.4
  CLOUD_PROVIDER_AZURE_IMAGE_VERSION := 1.25.3
endif

.PHONY: azure-cloud-provider
azure-cloud-provider:
	@${HELM_COMMAND} install cloud-provider-azure/cloud-provider-azure --version=${CLOUD_PROVIDER_AZURE_CHART_VERSION} --generate-name --set infra.clusterName=test2-ua --set cloudControllerManager.clusterCIDR=${CLOUD_PROVIDER_AZURE_CIDR} --set cloudControllerManager.configureCloudRoutes=${CLOUD_PROVIDER_AZURE_CREATE_ROUTES} --set cloudControllerManager.imageTag=v${CLOUD_PROVIDER_AZURE_IMAGE_VERSION} --set cloudNodeManager.imageTag=v${CLOUD_PROVIDER_AZURE_IMAGE_VERSION}

.PHONY: deploy
deploy: azure-cloud-provider

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
