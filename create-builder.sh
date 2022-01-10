#! /bin/bash
buildkit_version=$1
(docker buildx rm v${buildkit_version} > /dev/null 2>&1 || true) && docker buildx create --name v${buildkit_version} --driver-opt network=host --driver-opt image="moby/buildkit:v${buildkit_version}"