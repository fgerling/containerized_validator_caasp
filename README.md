# containerized validator_caasp
## Build
```
sh ./build.sh
```

## Run

```
# Edit `config/validator_caasp.conf`.
# Add your SSH_KEY to `./config` or inside another directory that will be
# accessible inside the container and edit `SSH_KEY` in
# `config/validator_caasp.conf` accordingly.

# create a directory container the cluster created by `validator_caasp`.
mkdir ./cluster

# Run the container, mounting `config` and `cluster`.
# The arguments are given one-to-one to `validator_caasp`
podman run -v "$(pwd)/cluster:/app/cluster" \
           -v "$(pwd)/config:/app/config" \
           -ti localhost/validator_caasp:latest \
                -i -p openstack -t join -n1:1 -k
```
