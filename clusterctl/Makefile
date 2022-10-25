include ../env.$(ENVIRONMENT).mk
include ../common.mk

.PHONY: deploy
deploy: check
	@clusterctl init --infrastructure azure
	@clusterctl upgrade plan

.PHONY: delete
delete:
	@true

.PHONY: display
display:
	@true
