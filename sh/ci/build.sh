#!/bin/bash


# @see https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_UTIL_PATH=$DIR/../../docker-util

: ${ALPINE_VERSION:=latest}
: ${DOCKER_IMAGE_NAME:=travis-cli}
: ${IMAGE_SIZE_THRESHOLD:=35}

# build the image
docker build --build-arg ALPINE_VERSION=$ALPINE_VERSION --tag $DOCKER_IMAGE_NAME --compress --force-rm --squash .

# test the image size
$DOCKER_UTIL_PATH/sh/test-image-size.sh -i $DOCKER_IMAGE_NAME -t $IMAGE_SIZE_THRESHOLD

# get the Alpine version from the container
CONTAINER_ALPINE_VERSION=$(docker run --entrypoint cat --rm $DOCKER_IMAGE_NAME /etc/alpine-release)

# remove anything past <major>.<minor>
NORMALIZED_CONTAINER_ALPINE_VERSION=`expr "$CONTAINER_ALPINE_VERSION" : '\([0-9]*\.[0-9]*\)'`

# normalize the expected version to an actual version, not the name of a tag
case $ALPINE_VERSION in
  edge)
    EXPECTED_ALPINE_VERSION=3.6
    ;;
  latest)
    EXPECTED_ALPINE_VERSION=3.6
    ;;
  *)
    EXPECTED_ALPINE_VERSION=$ALPINE_VERSION
    ;;
esac

# validate Alpine version (<major.<minor> only)
if [ $NORMALIZED_CONTAINER_ALPINE_VERSION = $EXPECTED_ALPINE_VERSION ]; then
  echo "Passed: The normalized Alpine version ${NORMALIZED_CONTAINER_ALPINE_VERSION} matches the expected version."
else
  echo "Failed: The normalized Alpine version ${NORMALIZED_CONTAINER_ALPINE_VERSION} does not match the expected version ${EXPECTED_ALPINE_VERSION}."
  exit 1
fi
