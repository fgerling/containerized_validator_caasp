# containerized validator_caasp
This project containerize mravec's [`validator_caasp`][1] script in a **SLE
15** environment.

The container defines volumes for configuration files and cluster created by
`validator_caasp`.

Have a look at the `Dockerfile`, `config/validator_caasp.conf.example` and
`run.sh` to get an idea what is happening on build and runtime.

`scripts`, where `validator_caasp` and tests resides, is included as a git
submodule. The `scripts` repository is hosted on the suse gitlab instance. You
need access to this gitlab instance to make use of this project.

Finally, this project was originaly inspired and based on spiarh's
[`cagibi/containers/skuba-product/`][2] container.

## Build
```
# build.sh will download sonobuoy v15 and then build the container with validator_caasp:latest as target.
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

[1]: https://gitlab.suse.de/mkravec/scripts
[2]: https://github.com/spiarh/cagibi/tree/master/containers/skuba-product
