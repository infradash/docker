mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

gen-tag:
	echo "Version = $(BUILD_SRC_GIT_VERSION)"
	echo "Build Meta = $(BUILD_META)"
	echo "$(BUILD_META)" > ./MANIFEST
	echo "$(BUILD_SRC_GIT_VERSION)" > ./VERSION

# Copies special files pointed to by symlinks so Docker build can see the files.
dockerfile: gen-tag
	for i in `ls *.sh`; do cp $$i .tmp ; mv .tmp $$i ; done
	for i in `ls DASH_*`; do cp $$i .tmp ; mv .tmp $$i ; done


image: dockerfile
	docker build -t $(BUILD_DOCKER_IMAGE) .

push: image
	docker push $(BUILD_DOCKER_IMAGE)
