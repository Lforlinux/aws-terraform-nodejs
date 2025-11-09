-include .env
DOCKER_IMAGE ?= hashicorp/terraform:1.6
ROOT_DIR := /data
EXEC = docker run --rm -i \
					-e AWS_PROFILE=$(AWS_PROFILE) \
					-e KUBECONFIG=${ROOT_DIR}/kubeconfig.yaml \
					-v $(HOME)/.aws:/root/.aws \
					-v $(PWD):/data \
					-w /data \
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
	@echo ""
	@echo "To access the Kubernetes cluster, run:"
	@echo "aws eks --region $$($(EXEC) output -raw region) update-kubeconfig --name $$($(EXEC) output -raw cluster_name)"

.PHONY: apply-auto-approve
apply-auto-approve:
	@$(EXEC)  apply -auto-approve
	@echo ""
	@echo "To access the Kubernetes cluster, run:"
	@echo "aws eks --region $$($(EXEC) output -raw region) update-kubeconfig --name $$($(EXEC) output -raw cluster_name)"

.PHONY: destroy
destroy:
	@$(EXEC) destroy -no-color

.PHONY: deploy
deploy:
	@$(EXEC) init -no-color
	@$(EXEC) apply -no-color
	@echo ""
	@echo "To access the Kubernetes cluster, run:"
	@echo "aws eks --region $$($(EXEC) output -raw region) update-kubeconfig --name $$($(EXEC) output -raw cluster_name)"