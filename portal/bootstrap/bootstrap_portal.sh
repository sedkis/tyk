#!/bin/bash

########### Variables
dashboard_base_url="https://my-url-adm.aws-use1.cloud-ara.tyk.io"
dashboard_user_api_credentials="myuserapikey"
organisation_id="myorgid"
############ Fill these in

function log_message {
  echo "$(date -u) $1"
}
function log_json_result {
  status=$(echo $1 | jq -r '.Status')
  if [ "$status" = "OK" ] || [ "$status" = "Ok" ]
  then
    log_ok
  else
    log_message "  ERROR: $(echo $1 | jq -r '.Message')"
    exit 1
  fi
}
function log_ok {
  log_message "  Ok"
}

log_message "Creating Portal for organisation $organisation_name"

log_message "  Creating Portal default settings"
log_json_result "$(curl $dashboard_base_url/api/portal/configuration \
  -H "Authorization: $dashboard_user_api_credentials" \
  -d "{}" 2>> bootstrap.log)"

log_message "  Initialising Catalogue"
result=$(curl $dashboard_base_url/api/portal/catalogue \
  -H "Authorization: $dashboard_user_api_credentials" \
  -d '{"org_id": "'$organisation_id'"}' 2>> bootstrap.log)
catalogue_id=$(echo "$result" | jq -r '.Message')
log_json_result "$result"

log_message "  Creating Portal home page"
log_json_result "$(curl $dashboard_base_url/api/portal/pages \
  -H "Authorization: $dashboard_user_api_credentials" \
  -d '{
  "is_homepage": true,
  "template_name": "",
  "title": "Developer Portal Home",
  "slug": "/",
  "fields": {
    "JumboCTATitle": "Tyk Developer Portal",
    "SubHeading": "Sub Header",
    "JumboCTALink": "#cta",
    "JumboCTALinkTitle": "Your awesome APIs, hosted with Tyk!",
    "PanelOneContent": "Panel 1 content.",
    "PanelOneLink": "#panel1",
    "PanelOneLinkTitle": "Panel 1 Button",
    "PanelOneTitle": "Panel 1 Title",
    "PanelThereeContent": "",
    "PanelThreeContent": "Panel 3 content.",
    "PanelThreeLink": "#panel3",
    "PanelThreeLinkTitle": "Panel 3 Button",
    "PanelThreeTitle": "Panel 3 Title",
    "PanelTwoContent": "Panel 2 content.",
    "PanelTwoLink": "#panel2",
    "PanelTwoLinkTitle": "Panel 2 Button",
    "PanelTwoTitle": "Panel 2 Title"
  }
}')"

