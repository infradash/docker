#!/bin/bash

# Domain in the registry for the images
export BUILD_RELEASE_DOMAIN=docker.infradash.com

# Docker hub login information
export BUILD_DOCKER_LOGIN=/docker.infradash.com/.dockercfg

export ZOOKEEPER_HOST=zk01.qor.io:2181
export BUILD_BASTION_LOGIN=ubuntu@bastion.qoriolabs.com 

# Docker hub account
export BUILD_DOCKER_REPO=infradash

# If checking out code -- update this in the branch
export BUILD_SRC_GIT_REPO=$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME
export BUILD_SRC_GIT_VERSION=$CIRCLE_BRANCH

# The build directory -- where Dockerfile lives.
# This assumes the convention of branch name matching the directory (e.g. postgres/9.3)
export BUILD_DIR=$CIRCLE_BRANCH

# Branch name is the product (e.g. postgres/9.3)
export BUILD_PRODUCT=$(echo $BUILD_DIR | awk -F "/" '{print $1}')
export PRODUCT_VERSION=$(echo $BUILD_DIR | awk -F "/" '{print $2}')

if [[ "$PRODUCT_VERSION" = "" ]]; then
    BUILD_LABEL=${CIRCLE_BUILD_NUM}
else
    BUILD_LABEL=${PRODUCT_VERSION}-${CIRCLE_BUILD_NUM}
fi

# The docker image to build, with tag:
export BUILD_DOCKER_IMAGE=$BUILD_DOCKER_REPO/$BUILD_PRODUCT:$BUILD_LABEL
export BUILD_META="repo=$BUILD_SRC_GIT_REPO,version=$BUILD_SRC_GIT_VERSION,build=$BUILD_LABEL,image=$BUILD_DOCKER_IMAGE"

env | sort | grep BUILD_

$@
