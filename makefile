.PHONY: test

EXECUTABLES = terraform go config-lint
K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, please install before running make")))

build: init validate lint test

init :
	terraform init basic-infra
format :
	terraform fmt -recursive basic-infra
validate :
	terraform validate basic-infra && terraform plan
lint :
	config-lint -terraform basic-infra/main.tf
test :
	cd test; go test -v -timeout 30m