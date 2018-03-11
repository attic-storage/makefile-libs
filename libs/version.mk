VERSION := $(shell cat VERSION)
FRESH_VERSION = $(shell cat VERSION)
GITHASH := $(shell git rev-parse --short HEAD)
VERSION_BUILDHASH = $(VERSION)-$(GITHASH)

GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
	GITHASH := $(GITHASH)-dirty
endif

FIRST_RELEASE?=false
bump: ## Bump your project version
	@npm i -g standard-version
	@echo '{"version": "$(VERSION)",' > package.json
	@echo '"standard-version": {"skip": {"commit": true,"tag": true}}}' >> package.json
	@standard-version $(if $(filter true,$(FIRST_RELEASE)),--first-release,)
	@jq -r ".version" package.json > VERSION
	@rm -rf package.json
	@git add -A .
	@git commit -q -am "chore: bump to $(FRESH_VERSION)"
	@git tag $(FRESH_VERSION)
	@git push origin HEAD $(FRESH_VERSION)
	