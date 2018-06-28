CMD?=
TARGET?=1.0
PYPI_SERVER?="pypi.org"
PYPI_INDEX?="https://${PYPI_SERVER}/simple/"
DOCKER_IMAGE=unicef/sir-backend:${TARGET}
DOCKERFILE?=Dockerfile
BUILD_OPTIONS?=--squash --rm

builder:
	docker build ${BUILD_OPTIONS} \
			--target builder \
			--build-arg PYPI_SERVER=${PYPI_SERVER} \
			--build-arg PYPI_INDEX=${PYPI_INDEX} \
			-t ${DOCKER_IMAGE} \
			-f ${DOCKERFILE} .

build:
	docker build ${BUILD_OPTIONS} \
			--build-arg PYPI_SERVER=${PYPI_SERVER} \
			--build-arg PYPI_INDEX=${PYPI_INDEX} \
			--build-arg GITHUB_CREDENTIALS=${GITHUB_CREDENTIALS} \
			-t ${DOCKER_IMAGE} \
			-f Dockerfile .

run:
	docker run -p 8000:8000 --rm \
			-e DATABASE_URL=${DATABASE_URL} \
			-e DEBUG=true \
			-e SECURE_SSL_REDIRECT=false \
			-e SESSION_COOKIE_SECURE=false \
			-e SESSION_COOKIE_HTTPONLY=false \
			-e SESSION_COOKIE_HTTPONLY=false \
			-e CSRF_COOKIE_SECURE=false \
			-e STATIC_ROOT=/var/sir/static/ \
			-e DJANGO_SETTINGS_MODULE=sir.config.settings.default \
			-v $$PWD/~build/volumes/var/sir/:/var/sir/ \
			-it ${DOCKER_IMAGE} \
			${CMD}

test:
#	CMD="\"sh -c \'python -c \\\"import sir\'\\\"\"" $(MAKE) run
	CMD='django-admin check --deploy' $(MAKE) run
