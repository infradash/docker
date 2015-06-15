gen-tag:
	echo "Build Meta = $(BUILD_META)"
	echo "Version = $(BUILD_SRC_GIT_VERSION)"
	echo "Dasher = $(DASH_URL)"
	echo "$(BUILD_META)" > ./MANIFEST
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION
	echo "$(DASH_URL)" > ./GET_DASH
	echo "aws ec2 describe-regions" > ./DASH_CMD

	ls -al

dockerfile: gen-tag
	chmod a+x ./aws-cli.sh

image: dockerfile
	sudo docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	sudo docker push $(BUILD_DOCKER_IMAGE)
