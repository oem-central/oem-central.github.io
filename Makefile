BASE_IMAGE=ruby:2.4
IMAGE_NAME=oem-central.com
IMAGE_TAG=develop
IMAGE=${IMAGE_NAME}:${IMAGE_TAG}

DOCKER=docker
DOCKER_ARGS=-v ${PWD}:/src -w /src -u `id -u`:`id -g` # This works on Linux
DOCKER_SERVER_PORT_ARGS=-p 4000:4000
DOCKER_SHELL_PORT_ARGS=-p 4004:4000

ENV=--env-file .env
RM=rm -rf

image:
	${DOCKER} build \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		-t ${IMAGE} \
		.

shell:
	${DOCKER} run \
		--rm -it ${DOCKER_SHELL_PORT_ARGS} ${DOCKER_ARGS} ${IMAGE} \
		/bin/bash

server:
	${RM} _site
	${DOCKER} run \
		--rm -it ${DOCKER_SERVER_PORT_ARGS} ${DOCKER_ARGS} ${ENV} ${IMAGE} \
		jekyll serve -H 127.0.0.1 -wD

.PHONY: \
	image \
	shell \
	server
