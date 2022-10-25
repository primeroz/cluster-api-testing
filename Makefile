# https://raw.githubusercontent.com/FikaWorks/deploy-kubernetes-addons-makefile-example/master/Makefile
include common.mk
include env.$(ENVIRONMENT).mk

.DEFAULT_GOAL := help

.PHONY: all
all: switch-kubectl-context deploy-all

.PHONY: switch-kubectl-context
switch-kubectl-context: ## Set kubectl context based on the KUBE_CONTEXT environment variable, by default it is defined in the `env.<ENVIRONMENT>.mk` file
	kubectl config use-context $(KUBE_CONTEXT)

.PHONY: deploy-all
deploy-all: $(foreach app,$(APPS),deploy-$(app)) ## Deploy all application to a given environment

.PHONY: kind-create kind-delete kind-display
kind-create: ## Create Kind Cluster
	$(MAKE) -C kind/ -e ENVIRONMENT=$(ENVIRONMENT) deploy
kind-delete: ## delete Kind Cluster
	$(MAKE) -C kind/ -e ENVIRONMENT=$(ENVIRONMENT) delete
kind-display: ## display Kind Cluster
	$(MAKE) -C kind/ -e ENVIRONMENT=$(ENVIRONMENT) display

deploy-%: switch-kubectl-context ## Deploy a single application to a given environment
	$(MAKE) -C $* -e ENVIRONMENT=$(ENVIRONMENT) deploy

.PHONY: deploy-%
deploy-%: switch-kubectl-context ## Deploy a single application to a given environment
	$(MAKE) -C $* -e ENVIRONMENT=$(ENVIRONMENT) deploy

.PHONY: delete-%
delete-%: switch-kubectl-context ## Deploy a single application to a given environment
	$(MAKE) -C $* -e ENVIRONMENT=$(ENVIRONMENT) delete

.PHONY: display-%
display-%: switch-kubectl-context ## display a single application
	$(MAKE) -C $* -e ENVIRONMENT=$(ENVIRONMENT) display

.PHONY: test-secrets
test-secrets:
	@echo ${AZURE_FAKE_SECRET}

.PHONY: help
help: ## Display this help. Thanks to https://suva.sh/posts/well-documented-makefiles/
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
