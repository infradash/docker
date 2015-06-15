gen-tag:
	echo "Build Meta = $(BUILD_META)"
	echo "Version = $(BUILD_SRC_GIT_VERSION)"
	echo "$(BUILD_META)" > ./MANIFEST
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION

dockerfile: gen-tag
	chmod a+x ./postgres.sh

image: dockerfile
	docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	docker push $(BUILD_DOCKER_IMAGE)
