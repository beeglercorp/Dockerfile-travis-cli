#!/bin/bash


# recommended by travis-ci
# @see https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
set -ev

# @see https://stackoverflow.com/a/246128
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_UTIL_PATH=$DIR/../../docker-util

: ${DOCKER_IMAGE_NAME:=travis-cli}
: ${DOCKER_PUBLIC_IMAGE_NAME:=beeglercorpstage/$DOCKER_IMAGE_NAME}
: ${TAG:=latest}

# push the image to Docker's repository
$DOCKER_UTIL_PATH/sh/push-image.sh -i $DOCKER_IMAGE_NAME -n $DOCKER_PUBLIC_IMAGE_NAME -p $DOCKER_PASSWORD -t $TAG -u $DOCKER_USERNAME
