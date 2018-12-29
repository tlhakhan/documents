#!/bin/bash

hostname=$1
mem_size=$(($2 * 1024))
data_size=$(($3 * 1024))
image_uuid=$4

if [[ $# -ne 4 ]]
then
  echo "hostname, mem size (gb), data size (gb) and image_uuid must be provided"
  exit 1 
else
  echo $hostname $mem_size $data_size $image_uuid
fi

dns1="192.168.100.1"
pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+B6xVQx5giGb7uJ+lvdWZEGJgIufq23wr/xGMin4f0+3LB3qDIt536kknG2j35V7BKqpPqF87IrAwtdNC91XKrDuJJ2UafEoeQnDjz8VFdD/SWrkvbiE7UfkVwjgJrpDcgGrcAe5K2Q2ZD4y6v/Ij2CdTaNN0vv0te6VwpJwvt1c0gyNNNGZuc/FLcGPoNnCTXldf2o0rF9LhyJA6lIUFPL7cE6lVgt1k727CHxpYNGaNSOAHMg4N1x47pHw46tRsGVYdrVLjp0g5DQPzUcGaE3eBqC5Hs3kYixbdpvP9Yi6rZZlFJe7EniPnpBsDyEbhnGYmyNW8Brucm61SzM8d root@packer-00"

vmadm create << eof 
 {
  "brand": "kvm",
  "cpu_shares":"100",
  "vcpus":"4",
  "disks":[
   {
    "image_uuid": "$image_uuid",
    "boot": true,
    "model":"virtio",
    "compression":"lz4"
  }, {
    "size": $data_size,
    "compression":"lz4",
    "model":"virtio"
  }],
   "alias":"$hostname",
   "hostname":"$hostname",
   "ram": $mem_size,
   "resolvers":["$dns1"],
   "nics": [
     {
       "nic_tag": "admin",
       "ips": ["dhcp"],
       "primary": true,
      "model":"virtio"
     }
   ],
  "customer_metadata":{
    "root_authorized_keys": "$pub_key",
    "user-script":"/usr/sbin/mdata-get root_pw | passwd --stdin root"
  },
  "internal_metadata":{
    "root_pw":"root",
    "admin_pw":"admin"
  }
 }
eof
