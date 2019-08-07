#! /bin/sh
## get sonobuoy v0.15.1
SONOBUOY_VERSION="0.15.1"
SONOBUOY_OS="linux"
SONOBUOY_ARCH="amd64"
sonobuoy_tar="sonobuoy_${SONOBUOY_VERSION}_${SONOBUOY_OS}_${SONOBUOY_ARCH}.tar.gz"
if test ! -f ./${sonobuoy_tar}
then
	curl -O -L "https://github.com/heptio/sonobuoy/releases/download/v${SONOBUOY_VERSION}/${sonobuoy_tar}"
	tar xvf $sonobuoy_tar
fi

podman build -t validator_caasp:latest .
