#!/bin/bash

# External depedencies
: ${BUILD_PROJECT:=$CIRCLE_PROJECT_USERNAME}
: ${BUILD_REPO:=$CIRCLE_PROJECT_REPONAME}
: ${BUILD_BRANCH:=$CIRCLE_BRANCH}
: ${BUILD_NUM:=$CIRCLE_BUILD_NUM}

# Domain in the registry for the images
export BUILD_RELEASE_DOMAIN=docker.infradash.com

# Docker hub login information
export BUILD_DOCKER_LOGIN=/docker.infradash.com/.dockercfg

export ZOOKEEPER_HOST=zk01.qor.io:2181
export BUILD_BASTION_LOGIN=ubuntu@bastion.qoriolabs.com 

# Docker hub account
export BUILD_DOCKER_REPO=infradash

# If checking out code -- update this in the branch
export BUILD_SRC_GIT_REPO=$BUILD_PROJECT/$BUILD_REPO
export BUILD_SRC_GIT_VERSION=$BUILD_BRANCH
export BUILD_SRC_BUILD=$BUILD_NUM


# The build directory -- where Dockerfile lives.
# This assumes the convention of branch name matching the directory (e.g. postgres/9.3)
export BUILD_DIR=$BUILD_BRANCH

# Branch name is the product (e.g. postgres/9.3)
export BUILD_PRODUCT=$(echo $BUILD_DIR | awk -F "/" '{print $1}')
export PRODUCT_VERSION=$(echo $BUILD_DIR | awk -F "/" '{print $2}')

if [[ "$PRODUCT_VERSION" = "" ]]; then
    BUILD_LABEL=${BUILD_NUM}
else
    BUILD_LABEL=${PRODUCT_VERSION}-${BUILD_NUM}
fi

# The docker image to build, with tag:
export BUILD_DOCKER_IMAGE=$BUILD_DOCKER_REPO/$BUILD_PRODUCT:$BUILD_LABEL
export BUILD_META="repo=$BUILD_SRC_GIT_REPO,version=$BUILD_SRC_GIT_VERSION,build=$BUILD_LABEL,image=$BUILD_DOCKER_IMAGE"

# Make it a full path
export BUILD_DIR=$(dirname $0)/$BUILD_DIR

env | sort | grep BUILD_

$@
