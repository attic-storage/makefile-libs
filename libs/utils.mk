PREFIX?=$(shell pwd)

getenv-%:
	@echo $($*) 

.PHONY: printvars
printvars: ## Print all makefile variables
	$(foreach V, $(sort $(.VARIABLES)), $(if $(filter-out environment% default automatic, $(origin $V)), $(warning $V=$($V) ($(value $V)))))

.PHONY: help
help: ## Print this message
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
