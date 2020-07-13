#!/bin/bash

## Edit these
local_dashboard=https://admin.cloud.tyk.io
local_dashboard_api_key=12345
remote_dashboard=http://host.docker.internal:3000
remote_dashboard_api_key=7b5d4aa3456346d448304e1e586e12a8
remote_org_id=5e9d9544a1dcd60001d0ed20

## don't need to edit probably
# tyk_sync_version=tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740
tyk_sync_version=sedkis/tyk-sync:master-2

### create tmp directory
mkdir tmp
cd tmp

### download stuff onto local file system
 docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 $tyk_sync_version \
 dump \
 -d="$local_dashboard" \
 -s="$local_dashboard_api_key" \
 -t="./tmp"


### push to new dashboard
docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
$tyk_sync_version \
 sync \
 -d="$remote_dashboard" \
 -s="$remote_dashboard_api_key" \
 -p "tmp" \
 -o="$remote_org_id"

## cleanup tmp stuff
rm *
rm .tyk.json
cd ..
rmdir tmp
