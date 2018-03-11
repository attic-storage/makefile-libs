# include library makefiles
include libs/os.mk
include libs/utils.mk 

# Specific to Git and version
include libs/version.mk

# Specific to Golang
include libs/go.mk

.DEFAULT_GOAL := help

test: help printvars ## Test for travis-ci