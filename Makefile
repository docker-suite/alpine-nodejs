## Name of the image
DOCKER_IMAGE=dsuite/alpine-nodejs

## Current directory
DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

## Define the latest version
latest = 13
lts=12
current=13

## Config
.DEFAULT_GOAL := help
.PHONY: *

help: ## This help!
	@printf "\033[33mUsage:\033[0m\n  make [target] [arg=\"val\"...]\n\n\033[33mTargets:\033[0m\n"
	@grep -E '^[-a-zA-Z0-9_\.\/]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Build all versions
	@$(MAKE) build-version v=8
	@$(MAKE) build-version v=10
	@$(MAKE) build-version v=11
	@$(MAKE) build-version v=12
	@$(MAKE) build-version v=13

test: ## Test all versions
	@$(MAKE) test-version v=8
	@$(MAKE) test-version v=10
	@$(MAKE) test-version v=11
	@$(MAKE) test-version v=12
	@$(MAKE) test-version v=13

push: ## Push all versions
	@$(MAKE) push-version v=8
	@$(MAKE) push-version v=10
	@$(MAKE) push-version v=11
	@$(MAKE) push-version v=12
	@$(MAKE) push-version v=13

shell: ## Run shell ( usage : make shell v="3.10" )
	$(eval version := $(or $(v),$(latest)))
	@$(MAKE) build-version v=$(version)
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(version) \
		bash

remove: ## Remove all generated images
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{} || true
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 3 | xargs -I {} docker rmi {} || true

readme: ## Generate docker hub full description
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater

build-version:
	$(eval version := $(or $(v),$(latest)))
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NODE_VERSION=$(version) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(version)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(version) \
		--tag $(DOCKER_IMAGE):$(version) \
		$(DIR)/Dockerfiles
	@[ "$(version)" = "$(lts)" ] && docker tag $(DOCKER_IMAGE):$(version) $(DOCKER_IMAGE):lts || true
	@[ "$(version)" = "$(current)" ] && docker tag $(DOCKER_IMAGE):$(version) $(DOCKER_IMAGE):current || true
	@[ "$(version)" = "$(latest)" ] && docker tag $(DOCKER_IMAGE):$(version) $(DOCKER_IMAGE):latest || true

test-version:
	$(eval version := $(or $(v),$(latest)))
	@$(MAKE) build-version v=$(version)
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(version)

push-version:
	$(eval version := $(or $(v),$(latest)))
	@$(MAKE) build-version v=$(version)
	@docker push $(DOCKER_IMAGE):$(version)
	@[ "$(version)" = "$(lts)" ] && docker push $(DOCKER_IMAGE):lts || true
	@[ "$(version)" = "$(current)" ] && docker push $(DOCKER_IMAGE):current || true
	@[ "$(version)" = "$(latest)" ] && docker push $(DOCKER_IMAGE):latest || true
