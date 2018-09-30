#!/bin/bash

# vars
nexus_server='http://nexus-00.cloudcity.local:8081'
repo_name=$1
repo_url=$2

data_file=$(mktemp)

cat << eof > "$data_file"
{
    "action": "coreui_Repository",
    "method": "create",
    "data": [{
        "attributes": {
            "proxy": {
                "remoteUrl": "${repo_url}",
                "contentMaxAge": -1,
                "metadataMaxAge": 1440
            },
            "httpclient": {
                "blocked": false,
                "autoBlock": true
            },
            "storage": {
                "blobStoreName": "default",
                "strictContentTypeValidation": false
            },
            "negativeCache": {
                "enabled": true,
                "timeToLive": 1440
            }
        },
        "name": "${repo_name}",
        "format": "",
        "type": "",
        "url": "",
        "online": true,
        "authEnabled": false,
        "httpRequestSettings": false,
        "recipe": "raw-proxy"
    }],
    "type": "rpc",
    "tid": 0
}
eof

curl -H "Content-Type: application/json" -u admin:admin123 -d @"$data_file" -X POST "${nexus_server}/service/extdirect"
rm "$data_file"
