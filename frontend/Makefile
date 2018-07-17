CMD?=
TARGET?=1.0a
DOCKER_IMAGE=unicef/sir-fe
DOCKERFILE?=Dockerfile
BUILD_OPTIONS?=--squash --rm

builder:
	docker build ${BUILD_OPTIONS} \
			--target builder \
			--build-arg PYPI_SERVER=${PYPI_SERVER} \
			--build-arg PYPI_INDEX=${PYPI_INDEX} \
			-t ${DOCKER_IMAGE} \
			-f ${DOCKERFILE} .

clean:
	-docker rmi ${DOCKER_IMAGE}:${TARGET}

build:
	docker build ${BUILD_OPTIONS} \
			--build-arg GITHUB_TOKEN=${GITHUB_TOKEN} \
			--build-arg VERSION=${TARGET} \
			-t ${DOCKER_IMAGE}:${TARGET} \
			-f Dockerfile .

run:
	docker run -p 8000:8081 --rm \
			-it ${DOCKER_IMAGE}:${TARGET} \
			${CMD}

push:
	docker tag ${DOCKER_IMAGE}:${TARGET} ${DOCKER_IMAGE}:${TARGET}
	docker tag ${DOCKER_IMAGE}:${TARGET} ${DOCKER_IMAGE}:latest
	docker push ${DOCKER_IMAGE}:${TARGET}
	docker push ${DOCKER_IMAGE}:latest


test:
#	CMD="\"sh -c \'python -c \\\"import sir\'\\\"\"" $(MAKE) run
	CMD='django-admin check --deploy' $(MAKE) run

shell:
#	CMD="\"sh -c \'python -c \\\"import sir\'\\\"\"" $(MAKE) run
	CMD='/bin/sh' $(MAKE) run
