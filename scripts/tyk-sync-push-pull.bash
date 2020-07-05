#!/bin/bash

## Edit these
local_dashboard=https://admin.cloud.tyk.io/
local_dashboard_api_key=9581c604ba864b3878fe1f6b0d1643f8
remote_dashboard=http://34.71.229.10:3000
remote_dashboard_api_key=886aa81f2e0541d76096342fb1d3e38a
remote_org_id=5f01f092b8630e000183076f

### create tmp directory
mkdir tmp
cd tmp

### download stuff onto local file system
 docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740 \
 dump \
 -d="$local_dashboard" \
 -s="$local_dashboard_api_key" \
 -t="./tmp"


### push to new dashboard
docker run --rm \
 --mount type=bind,source="$(pwd)",target=/opt/tyk-sync/tmp \
 tykio/tyk-sync:v1.1.0-27-gbf4dd2f-3-g04f7740 \
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
