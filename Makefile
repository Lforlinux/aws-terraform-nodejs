-include .env
DOCKER_IMAGE ?= lforlinux/terraform:0.14.5
ROOT_DIR := /data
EXEC = docker run --rm -i $(pwd):/data $(DOCKER_IMAGE)
ROOT_DIR := /data
EXEC = docker run --rm -i \
					-e AWS_PROFILE=$(AWS_PROFILE) \
					-e KUBECONFIG=${ROOT_DIR}/kubeconfig.yaml \
					-v $(HOME)/.aws:/root/.aws \
					-v $(PWD):/data \
					$(DOCKER_IMAGE)

.PHONY: init
init:
	@$(EXEC)  init -no-color

.PHONY: plan
plan:
	@$(EXEC)  plan -no-color

.PHONY: apply
apply:
	@$(EXEC)  apply -no-color

.PHONY: apply-auto-approve
apply-auto-approve:
	@$(EXEC)  apply -auto-approve

.PHONY: destroy
destroy:
	@$(EXEC) destroy -no-color

.PHONY: deploy
deploy:
	@$(EXEC) init -no-color
	@$(EXEC) apply -no-color