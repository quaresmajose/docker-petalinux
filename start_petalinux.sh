#!/bin/bash

echo
echo "To pass the project source dir, use:"
echo "$0 -v /src/project:/home/vivado/projects"
echo
echo "Running:"

set -x
docker run -ti --rm --net=host $@ petalinux:latest
