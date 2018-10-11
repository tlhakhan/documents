#!/bin/bash

./lib/create_repo.sh epel-remote https://ewr.edge.kernel.org/fedora-buffet/epel/
./lib/create_repo.sh centos-remote http://mirror.centos.org/
./lib/create_repo.sh images-joyent-remote https://images.joyent.com
./lib/create_repo.sh jfrog-artifactory-remote https://jfrog.bintray.com/artifactory-rpms/
./lib/create_repo.sh jfrog-artifactory-pro-remote https://jfrog.bintray.com/artifactory-pro-rpms/
./lib/create_repo.sh mysql-remote http://repo.mysql.com/
./lib/create_repo.sh nginx-remote http://nginx.org/packages/
./lib/create_repo.sh pkgsrc-joyent-remote https://pkgsrc.joyent.com/packages/
./lib/create_repo.sh nexus-sonatype-remote https://download.sonatype.com/nexus/3/
./lib/create_repo.sh postgres-remote https://download.postgresql.org/pub/repos/yum/
