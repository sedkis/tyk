#!/bin/bash

## Edit these
local_dashboard=http://host.docker.internal:3000
local_dashboard_api_key=d98866b4a83b488954e05151de88da2f
remote_dashboard=http://remote-dash-host:3000/
remote_dashboard_api_key=my-key

### create tmp directory
mkdir tmp
cd tmp

### download stuff onto local file system
 docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740 \
 dump -d="$local_dashboard" -s="$local_dashboard_api_key" -t="./tmp"


### push to new dashboard
docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740 sync -d="$remote_dashboard" -s="$remote_dashboard_api_key" -p "tmp" -o="5efe192917f51f000155815d"

## cleanup tmp stuff
rm *
rm .tyk.json
cd ..
rmdir tmp