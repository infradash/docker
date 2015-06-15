mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

gen-tag:
	echo "Version = $(BUILD_SRC_GIT_VERSION)"
	echo "Build Meta = $(BUILD_META)"
	echo "$(BUILD_META)" > ./MANIFEST
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION

dockerfile: gen-tag
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION
	chmod a+x ./$(current_dir).sh

image: dockerfile
	docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	docker push $(BUILD_DOCKER_IMAGE)
