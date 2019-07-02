DIR:=$(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
PROJECT_NAME:=$(strip $(shell basename $(DIR)))
DOCKER_IMAGE=dsuite/$(PROJECT_NAME)


build: build-8 build-10 build-11 build-12

test: test-8 test-10 test-11 test-12

push: push-8 push-10 push-11 push-12

build-8:
	@$(eval NODE_VERSION := 8)
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NODE_VERSION=$(NODE_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NODE_VERSION)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NODE_VERSION) \
		--tag $(DOCKER_IMAGE):$(NODE_VERSION) \
		$(DIR)/Dockerfiles

build-10:
	@$(eval NODE_VERSION := 10)
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NODE_VERSION=$(NODE_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NODE_VERSION)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NODE_VERSION) \
		--tag $(DOCKER_IMAGE):$(NODE_VERSION) \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):$(NODE_VERSION) $(DOCKER_IMAGE):lts

build-11:
	@$(eval NODE_VERSION := 11)
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NODE_VERSION=$(NODE_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NODE_VERSION)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NODE_VERSION) \
		--tag $(DOCKER_IMAGE):$(NODE_VERSION) \
		$(DIR)/Dockerfiles

build-12:
	@$(eval NODE_VERSION := 12)
	@docker run --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e NODE_VERSION=$(NODE_VERSION) \
		-v $(DIR)/Dockerfiles:/data \
		dsuite/alpine-data \
		sh -c "templater Dockerfile.template > Dockerfile-$(NODE_VERSION)"
	@docker build \
		--build-arg http_proxy=${http_proxy} \
		--build-arg https_proxy=${https_proxy} \
		--file $(DIR)/Dockerfiles/Dockerfile-$(NODE_VERSION) \
		--tag $(DOCKER_IMAGE):$(NODE_VERSION) \
		$(DIR)/Dockerfiles
	@docker tag $(DOCKER_IMAGE):$(NODE_VERSION) $(DOCKER_IMAGE):current


test-8: build-8
	@$(eval NODE_VERSION := 8)
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run -e NODE_VERSION=$(NODE_VERSION) --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NODE_VERSION)

test-10: build-10
	@$(eval NODE_VERSION := 10)
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run -e NODE_VERSION=$(NODE_VERSION) --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NODE_VERSION)

test-11: build-11
	@$(eval NODE_VERSION := 11)
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run -e NODE_VERSION=$(NODE_VERSION) --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NODE_VERSION)

test-12: build-12
	@$(eval NODE_VERSION := 12)
	@docker run --rm -t \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-v $(DIR)/tests:/goss \
		-v /tmp:/tmp \
		-v /var/run/docker.sock:/var/run/docker.sock \
		dsuite/goss:latest \
		dgoss run -e NODE_VERSION=$(NODE_VERSION) --entrypoint=/goss/entrypoint.sh $(DOCKER_IMAGE):$(NODE_VERSION)

push-8: build-8
	@$(eval NODE_VERSION := 8)
	@docker push $(DOCKER_IMAGE):$(NODE_VERSION)

push-10: build-10
	@$(eval NODE_VERSION := 10)
	@docker push $(DOCKER_IMAGE):$(NODE_VERSION)
	@docker push $(DOCKER_IMAGE):lts

push-11: build-11
	@$(eval NODE_VERSION := 11)
	@docker push $(DOCKER_IMAGE):$(NODE_VERSION)

push-12: build-12
	@$(eval NODE_VERSION := 12)
	@docker push $(DOCKER_IMAGE):$(NODE_VERSION)
	@docker push $(DOCKER_IMAGE):current

shell-8: build-8
	@$(eval NODE_VERSION := 8)
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(NODE_VERSION) \
		bash

shell-10: build-10
	@$(eval NODE_VERSION := 10)
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(NODE_VERSION) \
		bash

shell-11: build-11
	@$(eval NODE_VERSION := 11)
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(NODE_VERSION) \
		bash

shell-12: build-12
	@$(eval NODE_VERSION := 12)
	@docker run -it --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		$(DOCKER_IMAGE):$(NODE_VERSION) \
		bash

remove:
	@docker images | grep $(DOCKER_IMAGE) | tr -s ' ' | cut -d ' ' -f 2 | xargs -I {} docker rmi $(DOCKER_IMAGE):{}

readme:
	@docker run -t --rm \
		-e http_proxy=${http_proxy} \
		-e https_proxy=${https_proxy} \
		-e DEBUG_LEVEL=DEBUG \
		-e DOCKER_USERNAME=${DOCKER_USERNAME} \
		-e DOCKER_PASSWORD=${DOCKER_PASSWORD} \
		-e DOCKER_IMAGE=${DOCKER_IMAGE} \
		-v $(DIR):/data \
		dsuite/hub-updater
