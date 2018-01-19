# creating a centos mirror 

```bash

# create /repo volume
mkdir /repo

# get yum-utils
yum install -y 
```


```bash
# file: /etc/cron.hourly/repo-sync.sh

#!/bin/bash

reposync -a x86_64 -r base -p /repo/centos/ -g -d -m
reposync -a x86_64 -r epel -p /repo/centos/ -g -d -m
reposync -a x86_64 -r extras -p /repo/centos/ -g -d -m
reposync -a x86_64 -r updates -p /repo/centos/ -g -d -m
createrepo --update /repo/centos/base/Packages
createrepo --update /repo/centos/epel/Packages
createrepo --update /repo/centos/extras/Packages
createrepo --update /repo/centos/updates/Packages

```

```bash
# file /repo/repo-00.repo

[local]
name=local repo
baseurl=http://repo-00/centos/base/Packages
gpgcheck=0
enabled=1

[local-updates]
name=local updates
baseurl=http://repo-00/centos/updates/Packages
gpgcheck=0
enabled=1

[local-epel]
name=local epel
baseurl=http://repo-00/centos/epel/Packages
gpgcheck=0
enabled=1

[local-misc]
name=local misc
baseurl=http://repo-00/centos/misc
gpgcheck=0
enabled=1

[local-artifactory]
name=local artifactory
baseurl=http://repo-00/centos/bintray--jfrog-artifactory-rpms
enabled=1
gpgcheck=0

```
