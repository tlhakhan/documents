#!/bin/bash

# vars
nexus_server='http://nexus-00.cloudcity.local:8081'
repo_name=$1

data_file=$(mktemp)

cat << eof > "$data_file"
{"action":"coreui_Repository","method":"remove","data":["${repo_name}"],"type":"rpc", "tid":0}
eof

curl -H "Content-Type: application/json" -u admin:admin123 -d @"$data_file" -X POST "${nexus_server}/service/extdirect"
rm "$create_file"
