#! /bin/sh

. /app/config/validator_caasp.conf
eval $(ssh-agent)
ssh-add "$SSH_KEY"
#./validator_caasp -i -p vmware -t=join,base,sono -n 3:3 -k
#./validator_caasp -i -p openstack -t join -n1:1
./validator_caasp $@
