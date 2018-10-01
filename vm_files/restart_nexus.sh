#!/bin/bash

vmadm list -H -o uuid,alias | grep nexus | awk '{print $1}' | xargs -n1 vmadm delete
vmadm create -f nexus-00.json.kvm
