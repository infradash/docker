gen-tag:
	echo "Build Meta = $(BUILD_META)"
	echo $(BUILD_META) > ./MANIFEST
	echo "Dasher = $(DASH_URL)"
	echo $(DASH_URL) > ./GET_DASH

dockerfile: gen-tag
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION
	chmod a+x ./haproxy.sh

image: dockerfile
	docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	docker push $(BUILD_DOCKER_IMAGE)
