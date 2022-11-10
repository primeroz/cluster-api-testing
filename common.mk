#common variables shared accross Makefiles
SHELL := bash -eo pipefail

AZURE_CHECK_ACCOUNT ?= "Azure FC 1"

ifndef ENVIRONMENT
$(error the variable ENVIRONMENT is not defined, run using `ENVIRONMENT=kind make deploy-all')
endif

#SECRET_SHOW := az keyvault secret show --vault-name $(AZURE_KEY_VAULT_NAME) --query 'value' -o tsv --name
