#!/bin/bash

./create_repo.sh epel-remote https://ewr.edge.kernel.org/fedora-buffet/epel/
./create_repo.sh centos-remote http://mirror.centos.org/
./create_repo.sh images-joyent-remote https://images.joyent.com
./create_repo.sh jfrog-artifactory-remote https://jfrog.bintray.com/artifactory-rpms/
./create_repo.sh jfrog-artifactory-pro-remote https://jfrog.bintray.com/artifactory-pro-rpms/
./create_repo.sh mysql-remote http://repo.mysql.com/
./create_repo.sh nginx-remote http://nginx.org/packages/
./create_repo.sh pkgsrc-joyent-remote https://pkgsrc.joyent.com/packages/
./create_repo.sh nexus-sonatype-remote https://download.sonatype.com/nexus/3/
