all:

TUNNEL_PORT:=$(shell bash -c 'echo $$(($$RANDOM + 5000))')
start-tunnel:
	ssh -L 127.0.0.1:$(TUNNEL_PORT):$(ZOOKEEPER_HOST) -fNM -S ./$(CIRCLE_BUILD_NUM).pid $(BUILD_BASTION_LOGIN)
	echo "$(TUNNEL_PORT)" > $(CIRCLE_BUILD_NUM).port
	echo "Sleeping while tunnel starts up."
	sleep 5

stop-tunnel:
	ssh -S ./$(CIRCLE_BUILD_NUM).pid -O check $(BUILD_BASTION_LOGIN)
	ssh -S ./$(CIRCLE_BUILD_NUM).pid -O exit $(BUILD_BASTION_LOGIN)
TUNNEL:=`cat ./$(CIRCLE_BUILD_NUM).port`

# Login to Docker using credentials in Zookeeper
docker-login:
	dash -zookeeper=localhost:$(TUNNEL) -readpath=$(BUILD_DOCKER_LOGIN) -read registry > ~/.dockercfg

setup-dir:
	echo "Copying to temp directory to build"
	sudo rm -rf /tmp/$(BUILD_DIR) && cp -rL $(BUILD_DIR) /tmp
	ls -al /tmp/$(BUILD_DIR)

get-dash: setup-dir
	echo "Getting dash from `cat $(BUILD_DIR)/DASH_BINARY`; copy to /tmp/$(BUILD_DIR)"
	cd /tmp/$(BUILD_DIR) && wget `cat ./DASH_BINARY` && chmod a+x dash && sudo cp dash /usr/bin

pre-image-build:
	echo "Releasing Product $(BUILD_PRODUCT) from $(BUILD_SRC_GIT_REPO) Version=$(BUILD_SRC_GIT_VERSION) Build=$(BUILD_SRC_BUILD) Image=$(BUILD_DOCKER_IMAGE), Build label is $(BUILD_LABEL)"

build-image: get-dash
	echo "Building and Pushing $(BUILD_DOCKER_IMAGE)"
	cd /tmp/$(BUILD_DIR) && make image

build-push-image: get-dash 
	echo "Building and Pushing $(BUILD_DOCKER_IMAGE)"
	cd /tmp/$(BUILD_DIR) && make push

begin-release:
	dash -logtostderr -zookeeper=localhost:$(TUNNEL) \
	-domain=$(BUILD_RELEASE_DOMAIN) \
	-service=$(BUILD_PRODUCT) \
	-version=$(BUILD_SRC_GIT_VERSION) \
	-build=$(BUILD_LABEL) \
	-image=$(BUILD_DOCKER_IMAGE) \
	-release \
	registry

commit-release:
	dash -logtostderr -zookeeper=localhost:$(TUNNEL) \
	-domain=$(BUILD_RELEASE_DOMAIN) \
	-service=$(BUILD_PRODUCT) \
	-version=$(BUILD_SRC_GIT_VERSION) \
	-build=$(BUILD_LABEL) \
	-image=$(BUILD_DOCKER_IMAGE) \
	-release -commit \
	registry
