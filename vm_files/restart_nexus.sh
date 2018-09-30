#!/bin/bash

vmadm list -H -o uuid | xargs -n1 vmadm delete
vmadm create -f nexus-00.json.kvm
