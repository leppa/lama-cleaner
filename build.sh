#!/usr/bin/env bash
set -e

VERSION=$1
DOCKERFILE_VERSION=0
IMAGE_DESC="Image inpainting tool powered by SOTA AI Model"
URL="https://github.com/Sanster/lama-cleaner"
SOURCE="https://github.com/leppa/lama-cleaner-docker"
IMAGE_NAME="leppa/lama-cleaner"
REGISTRY="ghcr.io"

export DOCKER_BUILDKIT=1

# Normal (GPU & CPU)
docker buildx build \
--file ./Dockerfile \
--label org.opencontainers.image.title=lama-cleaner \
--label org.opencontainers.image.description="$IMAGE_DESC" \
--label org.opencontainers.image.url=$URL \
--label org.opencontainers.image.source=$SOURCE \
--label org.opencontainers.image.version=$VERSION \
--build-arg version=$VERSION \
--tag $REGISTRY/$IMAGE_NAME:$VERSION-$DOCKERFILE_VERSION .

# CPU only (but much smaller)
docker buildx build \
--file ./Dockerfile \
--label org.opencontainers.image.title=lama-cleaner \
--label org.opencontainers.image.description="$IMAGE_DESC" \
--label org.opencontainers.image.url=$URL \
--label org.opencontainers.image.source=$SOURCE \
--label org.opencontainers.image.version=$VERSION \
--build-arg version=$VERSION \
--build-arg device=cpu \
--build-arg pip_install_torch_extra="--extra-index-url https://download.pytorch.org/whl/cpu" \
--tag $REGISTRY/$IMAGE_NAME:$VERSION-$DOCKERFILE_VERSION-cpuonly .

