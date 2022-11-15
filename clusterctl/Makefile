include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: init
init:
	@export EXP_MACHINE_POOL=true && \
	export EXP_CLUSTER_RESOURCE_SET=true && \
	export CLUSTER_TOPOLOGY=true && \
	clusterctl init --infrastructure azure

.PHONY: upgrade
upgrade:
	@clusterctl upgrade plan

.PHONY: deploy
deploy: init upgrade

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
