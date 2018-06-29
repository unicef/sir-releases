build:
	cd backend && $(MAKE) build
	cd frontend && $(MAKE) build

doit:
	set -x
	ls -al
	. update.sh
	cd backend && docker build \
			--build-arg GITHUB_CREDENTIALS=${GITHUB_CREDENTIALS} \
			-t unicef/sir-backend:${BACKEND_VERSION} \
			-f Dockerfile .
	docker images
