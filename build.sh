#! /bin/sh
## get sonobuoy v0.15.0
if test ! -f ./sonobuoy_0.15.0_darwin_amd64.tar.gz
then
	curl -O -L https://github.com/heptio/sonobuoy/releases/download/v0.15.0/sonobuoy_0.15.0_darwin_amd64.tar.gz
	tar xvf sonobuoy_0.15.0_darwin_amd64.tar.gz;
fi

podman build -t validator_caasp:latest .
