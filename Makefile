.PHONY: help \
		retrive \
		start stop down up connect \

TITLE_MAKEFILE=Nebula docker

SHELL=/bin/bash

export CURRENT_DIR := $(shell pwd)
export RED := $(shell tput setaf 1)
export RESET := $(shell tput sgr0)
export DATE_NOW := $(shell date)

IMAGE_NAME = ghcr.io/manprint/nebula:1.5.2
CONTAINER_NAME = nebula

.DEFAULT := help

help:
	@printf "\n$(RED)$(TITLE_MAKEFILE)$(RESET)\n"
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo

##@ Configuration Nebula

retrive: ## Retrive example configuration file from container
	@docker run --rm ${IMAGE_NAME} cat /root/nebula/config/config.example.yml > config.example.yml

##@ Run

start: ## Start nebula container (if exist)
	@docker start $(CONTAINER)

stop: ## Stop nebula container
	-@docker stop ${CONTAINER_NAME}

down: stop ## Destroy nebula container
	-@docker rm ${CONTAINER_NAME}

up: destroy ## Run the image
	@docker run -dit \
		--name=${CONTAINER_NAME} \
		--hostname=nebula-srv \
		--cap-add=NET_ADMIN \
		--network=host \
		--volume=${CURRENT_DIR}/config.yml:/root/nebula/config/config.yaml:ro \
		--volume=${CURRENT_DIR}/ca.crt:/root/nebula/certs/ca.crt:ro \
		--volume=${CURRENT_DIR}/host.crt:/root/nebula/certs/host.crt:ro \
		--volume=${CURRENT_DIR}/host.key:/root/nebula/certs/host.key:ro \
		${IMAGE_NAME}

##@ Connect Nebula

connect: ## Connect to container
	@echo "Wait for docker container $(CONTAINER) ..."
	@sleep 5 # wait for container
	@docker exec -it ${CONTAINER_NAME} bash -l
