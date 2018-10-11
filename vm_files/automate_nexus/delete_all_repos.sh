#!/bin/bash

./lib/delete_repo.sh maven-central
./lib/delete_repo.sh maven-snapshots
./lib/delete_repo.sh maven-releases
./lib/delete_repo.sh maven-public
./lib/delete_repo.sh nuget-group
./lib/delete_repo.sh nuget-hosted
./lib/delete_repo.sh nuget.org-proxy
