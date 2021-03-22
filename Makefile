.PHONY: help create-variables build init apply destroy
.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

create-variables: ## create variables files
	@cp variables_sample.json variables.json
	@cp ansible/vars/ansible_sample.json ansible/vars/ansible.json

build: ## build the packer image
	@packer build -var-file=variables.json packer/

init: ## generate documentation using pdoc
	@terraform init terraform/

apply: ## create infraestructure
	@terraform apply -var-file=variables.json terraform/

destroy: ## destroy infrastructure
	@terraform destroy -var-file=variables.json terraform/
