#!/bin/bash

hostname=$1
image_uuid=$2
ip_addr=$3
if [[ $# -ne 3 ]]
then
  echo "hostname, image_uuid and ip_addr is required."
  exit 1
fi

gateway=${ip_addr%.*}
dns_domain="$(domainname)"
dns1="$(cat /etc/resolv.conf | grep nameserver | awk '{print $NF}'| head -n1)"

pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+B6xVQx5giGb7uJ+lvdWZEGJgIufq23wr/xGMin4f0+3LB3qDIt536kknG2j35V7BKqpPqF87IrAwtdNC91XKrDuJJ2UafEoeQnDjz8VFdD/SWrkvbiE7UfkVwjgJrpDcgGrcAe5K2Q2ZD4y6v/Ij2CdTaNN0vv0te6VwpJwvt1c0gyNNNGZuc/FLcGPoNnCTXldf2o0rF9LhyJA6lIUFPL7cE6lVgt1k727CHxpYNGaNSOAHMg4N1x47pHw46tRsGVYdrVLjp0g5DQPzUcGaE3eBqC5Hs3kYixbdpvP9Yi6rZZlFJe7EniPnpBsDyEbhnGYmyNW8Brucm61SzM8d root@packer-00"

vmadm create << eof
{
             "brand": "joyent",
             "quota":"400",
             "image_uuid": "$image_uuid",
             "cpu_shares":"400",
             "max_physical_memory": 128,
             "alias": "$hostname",
             "dns_domain":"$dns_domain",
             "resolvers":["$dns1"],
             "nics": [
               {
                 "nic_tag": "admin",
                 "ips": ["$ip_addr/24"],
                "gateway":"$gateway.1",
                 "primary": true
               }
             ],
   "customer_metadata":{
    "hostname": "$hostname",
    "root_authorized_keys":"$pub_key",
  "user-script" : "/usr/sbin/mdata-get root_authorized_keys > /root/.ssh/authorized_keys; hostname \$(/usr/sbin/mdata-get hostname)"
  }
           }
eof
