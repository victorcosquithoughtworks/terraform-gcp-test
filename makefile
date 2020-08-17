.PHONY: test

EXECUTABLES = terraform go config-lint
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, please install before running make")))

build: init validate lint test

init :
	cd basic-infra; terraform init .
format :
	cd basic-infra; terraform fmt -recursive .
validate :
	cd basic-infra; terraform validate . && cd basic-infra; terraform plan .
lint :
	config-lint -terraform basic-infra/main.tf
test :
	cd test; go test -v -timeout 30m