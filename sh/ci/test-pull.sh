#!/bin/bash


: ${DOCKER_PUBLIC_IMAGE_NAME:=beeglercorpstage/travis-cli}
: ${TAG:=latest}
IMAGE_WITH_TAG=$DOCKER_PUBLIC_IMAGE_NAME:$TAG

# pull an existing image from the Docker registry
docker pull $IMAGE_WITH_TAG

# output the Travis CLI version
docker run --rm $IMAGE_WITH_TAG --version

# run `travis lint` against this repo's .travis.yml file
docker run --mount type=bind,source=$(pwd)/.travis.yml,target=/.travis.yml --rm $IMAGE_WITH_TAG lint /.travis.yml
