# creating a centos mirror 

```bash

# create /repo volume
mkdir /repo

# get yum-utils
yum install -y createrepo yum-utils
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

# creating a haproxy service
- build haproxy
- place haproxy in /usr/bin/haproxy
 
```bash

# file /etc/systemd/system/repo-http-haproxy.service

[Unit]
Description = repo http haproxy service
After = network.target

[Service]
ExecStart = /usr/bin/haproxy -f /etc/haproxy/haproxy.cfg
Restart = always

[Install]
WantedBy = multi-user.target

```

```bash

# file /etc/haproxy/haproxy.cfg

global
        maxconn 255

defaults
        mode http
        timeout connect 5000ms
        timeout client 5000ms
        timeout server 5000ms

frontend http-in
        bind *:80
        stats enable
        stats hide-version
        stats refresh 10s
        stats show-node
        stats auth admin:admin
        stats uri /haproxy?stats
        default_backend repo_servers

backend repo_servers
        server node8080 127.0.0.1:8080 maxconn 64 check
        server node8081 127.0.0.1:8081 maxconn 64 check
        server node8082 127.0.0.1:8082 maxconn 64 check
        server node8083 127.0.0.1:8083 maxconn 64 check

```

## create backend repo web servers
- copy/paste/modify - port number

```bash

# file /etc/systemd/system/repo-http-8080.service

[Unit]
Description = repo http 8080
After = network.target

[Service]
ExecStart = /usr/bin/http-server -p 8080 /repo
Restart = always

[Install]
WantedBy = multi-user.target

```
