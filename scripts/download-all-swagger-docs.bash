#!/bin/bash
dashboard_host="admin.cloud.tyk.io"
user_api_key="9581c604b....."

for documentId in $(curl https://$dashboard_host/api/portal/catalogue -H "Authorization:$user_api_key" | jq -r ".apis[].documentation"); do
    echo "Found doc ID: $documentId" 
    fileName="api_$documentId"
    curl --silent "https://workshop.cloud.tyk.io/portal/apis/$documentId/documentation/raw" | cat > $fileName
    echo "Saved Swagger Doc: $fileName"
done