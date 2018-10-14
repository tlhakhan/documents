#!/bin/bash

# user input vars
nexus_server=$1

#
# takes 1 argument: repo name
# deletes given repo using rest API
#
delete_repo() {
  
# function vars
repo_name=$1

data_file=$(mktemp)

cat << eof > "$data_file"
{"action":"coreui_Repository","method":"remove","data":["${repo_name}"],"type":"rpc", "tid":0}
eof

curl -H "Content-Type: application/json" -u admin:admin123 -d @"$data_file" -X POST "${nexus_server}/service/extdirect"
rm "$data_file"

}

# sanity check
if [[ $# -ne 1 ]]
then
  echo nexus_server required
  exit 1
fi

# delete default installed repos
delete_repo maven-central
delete_repo maven-snapshots
delete_repo maven-releases
delete_repo maven-public
delete_repo nuget-group
delete_repo nuget-hosted
delete_repo nuget.org-proxy
