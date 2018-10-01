#!/bin/bash

vmadm list -H -o uuid,alias | grep af | awk '{print $1}' | xargs -n1 vmadm delete
vmadm create -f af-00.json.kvm
