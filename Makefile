SHELL = /bin/sh
.DEFAULT_GOAL := help

export IMAGE_PYTORCH=jupyter-ml-pytorch
export IMAGE_TENSORFLOW=jupyter-ml-tensorflow
export TAG_PYTORCH=2.0.2
export TAG_TENSORFLOW=2.0.2

define _bumpversion
	# upgrades as $(subst $(1),,$@) version, commits and tags
	@docker run -it --rm -v $(PWD):/ml-lab \
		-u $(shell id -u):$(shell id -g) \
		itisfoundation/ci-service-integration-library:v1.0.1-dev-31 \
		sh -c "cd /ml-lab && bump2version --verbose --list --config-file $(1) $(subst $(2),,$@)"
endef

.PHONY: version-tensorflow-patch version-tensorflow-minor version-tensorflow-major
version-tensorflow-patch version-tensorflow-minor version-tensorflow-major: .bumpversion-tensorflow.cfg ## increases tensroflow service's version
	@make compose-spec
	@$(call _bumpversion,$<,version-tensorflow-)
	@make compose-spec

.PHONY: version-pytorch-patch version-pytorch-minor version-pytorch-major
version-pytorch-patch version-pytorch-minor version-pytorch-major: .bumpversion-pytorch.cfg ## increases pytorchservice's version
	@make compose-spec
	@$(call _bumpversion,$<,version-pytorch-)
	@make compose-spec

.PHONY: compose-spec
compose-spec: ## runs ooil to assemble the docker-compose.yml file
	@docker run -it --rm -v $(PWD):/ml-lab \
		-u $(shell id -u):$(shell id -g) \
		itisfoundation/ci-service-integration-library:v1.0.1-dev-31 \
		sh -c "cd /ml-lab && ooil compose"

.PHONY: build
build: compose-spec ## build docker images
	docker compose build

.PHONY: run-pytorch-local
run-pytorch-local: ## runs pytorch image with local configuration
	IMAGE_TO_RUN=${IMAGE_PYTORCH} \
	TAG_TO_RUN=${TAG_PYTORCH} \
	docker compose --file docker-compose-local.yml up

.PHONY: run-tensorflow-local
run-tensorflow-local: ## runs tensorflow image with local configuration
	IMAGE_TO_RUN=${IMAGE_TENSORFLOW} \
	TAG_TO_RUN=${TAG_TENSORFLOW} \
	docker compose --file docker-compose-local.yml up

publish-local:  ## push to local throw away registry to test integration
	@docker tag simcore/services/dynamic/${IMAGE_PYTORCH}:${TAG_PYTORCH} registry:5000/simcore/services/dynamic/${IMAGE_PYTORCH}:${TAG_PYTORCH}
	@docker tag simcore/services/dynamic/${IMAGE_TENSORFLOW}:${TAG_TENSORFLOW} registry:5000/simcore/services/dynamic/${IMAGE_TENSORFLOW}:${TAG_TENSORFLOW}
	@docker push registry:5000/simcore/services/dynamic/${IMAGE_PYTORCH}:${TAG_PYTORCH}
	@docker push registry:5000/simcore/services/dynamic/${IMAGE_TENSORFLOW}:${TAG_TENSORFLOW}

.PHONY: help
help: ## this colorful help
	@echo "Recipes for '$(notdir $(CURDIR))':"
	@echo ""
	@awk --posix 'BEGIN {FS = ":.*?## "} /^[[:alpha:][:space:]_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
