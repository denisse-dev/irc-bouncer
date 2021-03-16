.PHONY: help create-variables build
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create-variables: ## create variables files
	@cp variables_sample.json variables.json

build: ## build the packer image
	@packer build -var-file=variables.json packer/
