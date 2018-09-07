CMD?=
TARGET?=not_set
PYPI_SERVER?="pypi.org"
PYPI_INDEX?="https://${PYPI_SERVER}/simple/"
DOCKER_IMAGE=unicef/sir-be
DOCKERFILE?=Dockerfile
BUILD_OPTIONS?=--squash --rm

help:
	echo ""

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
			--build-arg GITHUB_CREDENTIALS=${GITHUB_TOKEN}: \
			--build-arg BACKEND_VERSION=${TARGET} \
			-t ${DOCKER_IMAGE}:${TARGET} \
			-f Dockerfile .

run:
	docker run -p 8000:8000 --rm \
			-e DATABASE_URL=${DATABASE_URL} \
			-e DEBUG=0 \
			-e SECURE_SSL_REDIRECT=1 \
			-e SESSION_COOKIE_SECURE=1 \
			-e SESSION_COOKIE_HTTPONLY=1 \
			-e SESSION_COOKIE_HTTPONLY=1 \
			-e CSRF_COOKIE_SECURE=1 \
			-e STATIC_ROOT=/var/sir/static/ \
			-e DJANGO_SETTINGS_MODULE=sir.config.settings.default \
			-v $$PWD/~build/volumes/var/sir/:/var/sir/ \
			-it ${DOCKER_IMAGE}:${TARGET} \
			${CMD}
push:
	docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
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
