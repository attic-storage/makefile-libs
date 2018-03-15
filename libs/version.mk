VERSION := $(shell head -n +1 VERSION)
GITHASH := $(shell git rev-parse --short HEAD)
GITBRANCH := $(shell git rev-parse --abbrev-ref HEAD)
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
REPOSITORY?=origin
RELEASE_BRANCH?=master
bump: ## Bump your project version
	@npm i -g standard-version
	@echo '{"version": "$(VERSION)"}' > package.json
	standard-version $(if $(filter true,$(FIRST_RELEASE)),--first-release,) --skip.commit --skip.tag
	@cat package.json | grep '"version"' | sed $(SED_REGEXP_FLAG) 's/^.*"version": *"(.*)".*/\1/' > VERSION
	@rm -rf package.json
	git add -A .
	git commit -am "chore: bump to $$(head -n +1 VERSION) [ci skip]"
	git tag $$(head -n +1 VERSION)
	git push $(REPOSITORY) $(GITBRANCH):$(RELEASE_BRANCH) $$(head -n +1 VERSION)

