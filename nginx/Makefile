gen-tag:
	echo "Build Meta = $(BUILD_META)"
	echo $(BUILD_META) > ./MANIFEST
	echo "Version = $(BUILD_SRC_GIT_VERSION)"
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION
	echo "Dasher = $(DASHER_URL)"
	echo $(DASHER_URL) > ./GET_DASHER
	ls -al

dockerfile: gen-tag
	chmod a+x ./nginx.sh

image: dockerfile
	sudo docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	sudo docker push $(BUILD_DOCKER_IMAGE)
