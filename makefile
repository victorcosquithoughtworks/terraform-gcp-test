.PHONY: test

EXECUTABLES = terraform go config-lint
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, please install before running make")))

build: init validate lint test

init :
	cd main; terraform init .
format :
	cd main; terraform fmt -recursive .
validate :
	cd main; terraform validate . && terraform plan .
lint :
	config-lint -terraform main/main.tf
test :
	cd test; go test -v -timeout 30m