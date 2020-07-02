#!/bin/bash

### create tmp directory
mkdir tmp
cd tmp

### download stuff onto local file system
 docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740 \
 dump -d="http://host.docker.internal:3000" -s="d98866b4a83b488954e05151de88da2f" -t="./tmp"


### push to new dashboard
docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740 sync -d="http://35.202.210.74:3000/" -s="0215a8fb37d2434e77f81e1f184a7292" -p "tmp" -o="5efe192917f51f000155815d"

## cleanup tmp stuff
rm *
cd ..
rmdir tmp