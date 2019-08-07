## config for /app/run.sh
# /app/config/ is the path inside the container
export SSH_KEY=/app/config/id_shared

## validator_caasp config
export SCC="INTERNAL-USE-ONLY-xxxxxxxxxxxxxxxx"
#export RMT="rmt.scc.suse.de"
export SUFFIX="username-beta5-sono-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 3)"

## vmware
export VSPHERE_SERVER="jazz.qa.prv.suse.net"
export VSPHERE_USER="username@jazz.qa.prv.suse.net"
export VSPHERE_PASSWORD="xxxxxxxxxxxxxx"
export VSPHERE_ALLOW_UNVERIFIED_SSL="true"

## openstack
export OS_AUTH_URL=https://engcloud.prv.suse.net:5000/v3
export OS_PROJECT_ID=05394ae447d74bc0b3ed2cca262c9b7c
export OS_PROJECT_NAME="container"
export OS_USER_DOMAIN_NAME="ldap_users"
if [ -z "$OS_USER_DOMAIN_NAME" ]; then unset OS_USER_DOMAIN_NAME; fi
export OS_PROJECT_DOMAIN_ID="default"
if [ -z "$OS_PROJECT_DOMAIN_ID" ]; then unset OS_PROJECT_DOMAIN_ID; fi
unset  OS_TENANT_ID
unset  OS_TENANT_NAME
export OS_USERNAME="username"
export OS_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxx"
export OS_REGION_NAME="CustomRegion"
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3



