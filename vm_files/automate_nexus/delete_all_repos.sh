#!/bin/bash

./delete_repo.sh maven-central
./delete_repo.sh maven-snapshots
./delete_repo.sh maven-releases
./delete_repo.sh maven-public
./delete_repo.sh nuget-group
./delete_repo.sh nuget-hosted
./delete_repo.sh nuget.org-proxy
