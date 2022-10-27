include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: init
init:
	@clusterctl init --infrastructure azure

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
