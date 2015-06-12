gen-tag:
	echo "Build Meta = $(BUILD_META)"
	echo $(BUILD_META) > ./MANIFEST
	echo "Version = $(BUILD_SRC_GIT_VERSION)"
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION
	echo "Dasher = $(DASH_URL)"
	echo $(DASH_URL) > ./GET_DASH
	ls -al

dockerfile: gen-tag
	chmod a+x ./aws-cli.sh

image: dockerfile
	sudo docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	sudo docker push $(BUILD_DOCKER_IMAGE)
