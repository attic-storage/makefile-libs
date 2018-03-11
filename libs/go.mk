# GO env vars
ifeq ($(GOPATH),)
	GOPATH:=~/go
endif
GO=$(firstword $(subst $(PATHSEP), ,$(GOPATH)))

.PHONY: ensure-vendor
ensure-vendor: ## Get all vendor dependencies
	@echo "+ $@"
	@go get -u github.com/golang/dep/cmd/dep
	dep ensure

.PHONY: update-vendor
update-vendor: ## Update all vendor dependencies
	@echo "+ $@"
	@go get -u github.com/golang/dep/cmd/dep
	dep ensure -update
