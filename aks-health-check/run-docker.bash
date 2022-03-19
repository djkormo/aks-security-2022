#!/usr/bin/env bash

while getopts r:i:v: option
do
case "${option}"
in
r) REPO=$(OPTARG);;
i) IMAGE=${OPTARG};;
v) VERSION=${OPTARG};;
esac
done

repo=${REPO:=ghcr.io}
image=${IMAGE:=boxboat/aks-health-check}
version=${VERSION:=latest}

echo "Running image: $repo/$image:$version"

#docker rm -f "aks-health-check" || true

docker run --network host --rm --name "aks-health-check" -it \
--mount type=bind,source="$(pwd)"/logs,target=/app/logs \
  --mount type=bind,source="$(pwd)",target=/app/bash \
  $repo/$image:$version

 # -v "${pwd}"logs:/app/logs 