.PHONY: _pwd_prompt dec enc

TUNNEL_PORT:= $(shell bash -c 'echo $$(($$RANDOM + 5000))')

# 'private' task for echoing instructions
_pwd_prompt: mk_dirs

# Make directories based the file paths
mk_dirs:
	@mkdir -p encrypt decrypt ;

# Decrypt files in the encrypt/ directory
decrypt: _pwd_prompt
	@echo "Decrypt the files in a given directory (those with .cast5 extension)."
	@read -p "Source directory: " src && read -p "Password: " password ; \
	mkdir -p decrypt/$${src} && echo "\n" ; \
	for i in `ls encrypt/$${src}/*.cast5` ; do \
		echo "Decrypting $${i}" ; \
		openssl cast5-cbc -d -in $${i} -out decrypt/$${src}/`basename $${i%.*}` -pass pass:$${password}; \
		chmod 600 decrypt/$${src}/`basename $${i%.*}` ; \
	done ; \
	echo "Decrypted files are in decrypt/$${src}"

# Encrypt files in the decrypt/ directory
encrypt: _pwd_prompt
	@echo "Encrypt the files in a directory using a password you specify.  A directory will be created under /encrypt."
	@read -p "Source directory name: " src && read -p "Password: " password && echo "\n"; \
	mkdir -p encrypt/`basename $${src}` ; \
	echo "Encrypting $${src} ==> encrypt/`basename $${src}`" ; \
	for i in `ls $${src}` ; do \
		echo "Encrypting $${src}/$${i}" ; \
		openssl cast5-cbc -e -in $${src}/$${i} -out encrypt/`basename $${src}`/$${i}.cast5 -pass pass:$${password}; \
	done ; \
	echo "Encrypted files are in encrypt/`basename $${src}`"

start-tunnel:
	ssh -L 127.0.0.1:$(TUNNEL_PORT):$(ZOOKEEPER_HOST) -fNM -S ./$(CIRCLE_BUILD_NUM).pid $(BUILD_BASTION_LOGIN)
	echo "$(TUNNEL_PORT)" > $(CIRCLE_BUILD_NUM).port

stop-tunnel:
	ssh -S ./$(CIRCLE_BUILD_NUM).pid -O check $(BUILD_BASTION_LOGIN)
	ssh -S ./$(CIRCLE_BUILD_NUM).pid -O exit $(BUILD_BASTION_LOGIN)

get-dash:
	DASH_URL:=$(cat ${BUILD_DIR}/DASH_BINARY)
	echo "Getting dash from $(DASH_URL); copy to $(BUILD_DIR)"
	wget $(DASH_URL) && chmod a+x dash && cp dash $(BUILD_DIR) && sudo cp dash /usr/bin

TUNNEL:=`cat ./$(CIRCLE_BUILD_NUM).port`

# Login to Docker using credentials in Zookeeper
docker-login:
	dash -zookeeper=localhost:$(TUNNEL) -readpath=$(BUILD_DOCKER_LOGIN) -read registry > ~/.dockercfg

pre-image-build:
	echo "Releasing Product $(BUILD_PRODUCT) from $(BUILD_SRC_GIT_REPO) Version=$(BUILD_SRC_GIT_VERSION) Build=$(BUILD_SRC_BUILD) Image=$(BUILD_DOCKER_IMAGE), Build label is $(BUILD_LABEL)"

build-push-image:
	echo "Building and Pushing $(BUILD_DOCKER_IMAGE)"
	cd $(BUILD_DIR) && make push

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
