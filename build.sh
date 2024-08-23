#!/bin/sh -e

BUILDDATE=$(date --iso-8601=seconds --utc)
BUILDREPO=$(git -C psiphon-tunnel-core config --get remote.origin.url)
BUILDREV=$(git -C psiphon-tunnel-core rev-parse --short HEAD)

docker build --build-arg BUILDDATE="$BUILDDATE" --build-arg BUILDREPO="$BUILDREPO" --build-arg BUILDREV="$BUILDREV" . "$@"
