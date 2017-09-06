#!/usr/bin/env bash

container=$1
period=$2

if docker ps | grep --quiet "\s${container}\s*\$"; then
  echo "Docker container ${container} is still running"
  exit -1
fi

cd "$(dirname "$0")"
cd "${container}"
chmod a+x script.sh
docker run -t --rm --name "${container}" \
    -v "$(pwd):/main" \
    --hostname=docker --privileged \
    --memory=6g --memory-swap=16g --oom-kill-disable \
    -e="period=${period}" \
    -w="/root" \
    yegor256/threecopies /main/script.sh \
    > log 2>&1; echo $? > exit
