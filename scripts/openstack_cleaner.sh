#!/usr/bin/env bash
set -eEuo pipefail

: ${1?"Usage: $0 ARGUMENT"}

SUFFIX="$1"

# delete instances
var=$(openstack server list --name "\-${SUFFIX}\-" -f json | jq '.[].ID' -r)
[ "$var" ] && openstack server delete $var

# delete load balancer
var=$(neutron lbaas-pool-show ${SUFFIX}-kube-api-pool -f json | jq '.healthmonitor_id' -r)
[ "$var" != "null" ] && neutron lbaas-healthmonitor-delete $var
neutron lbaas-pool-delete ${SUFFIX}-kube-api-pool
neutron lbaas-listener-delete ${SUFFIX}-api-server-listener
neutron lbaas-loadbalancer-delete ${SUFFIX}-lb

# delete router & network
var=$(openstack port list --router ${SUFFIX}-router -f json | jq '.[0].ID' -r)
[ "$var" != "null" ] && openstack router remove port ${SUFFIX}-router $var
openstack router delete ${SUFFIX}-router
openstack network delete ${SUFFIX}

# delete security groups
var=$(openstack security group list -f value | grep -w ${SUFFIX} | cut -d' ' -f1)
[ "$var" ] && openstack security group delete $var
