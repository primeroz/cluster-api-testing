include ../env.$(ENVIRONMENT).mk
include ../common.mk

ACCOUNT := $(shell az account show --query 'name')

.PHONY: check
check:
	$(info Checking if Azure account is correct)
	@if [[ $(ACCOUNT) != $(AZURE_CHECK_ACCOUNT) ]]; then\
		echo "Wrong Account";\
		false;\
	fi

.PHONY: deploy
deploy: check
	@echo "Create Azure Group"
	@az group create --location ${AZURE_LOCATION} -n ${AZURE_RESOURCE_GROUP}  --managed-by ${AZURE_SUBSCRIPTION} --tags "env=testing scope=cluster-api"

.PHONY: delete
delete: check
	@echo "Delete Azure Group"
	@echo az group delete -n ${AZURE_RESOURCE_GROUP} --force-deletion-types Microsoft.Compute/virtualMachines

.PHONY: display
display: check
	@echo "Display Azure group resources"
