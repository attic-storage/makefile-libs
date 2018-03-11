VERSION := $(shell cat VERSION)
FRESH_VERSION = $(shell cat VERSION)
GITHASH := $(shell git rev-parse --short HEAD)
VERSION_BUILDHASH = $(VERSION)-$(GITHASH)

GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
	GITHASH := $(GITHASH)-dirty
endif

# Multi-OS sed compliant
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	SED_REGEXP_FLAG=-r
endif
ifeq ($(UNAME_S),Darwin)
	SED_REGEXP_FLAG=-E
endif


FIRST_RELEASE?=false
bump: ## Bump your project version
	@npm i -g standard-version
	@echo '{"version": "$(VERSION)",' > package.json
	@echo '"standard-version": {"skip": {"commit": true,"tag": true}}}' >> package.json

	@standard-version $(if $(filter true,$(FIRST_RELEASE)),--first-release,)
	@cat package.json | grep '"version"' | sed $(SED_REGEXP_FLAG) 's/^.*"version": *"(.*)".*/\1/' > VERSION
	@rm -rf package.json
	@git add -A .
	@git commit -q -am "chore: bump to $(FRESH_VERSION)"
	@git tag $(FRESH_VERSION)
	@git push origin HEAD $(FRESH_VERSION)
	
	