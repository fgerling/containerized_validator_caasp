FROM registry.suse.com/suse/sle15

## Reducing repos count would be a good idea. What is really needed?
# SUSE:CA.repo: certificates needed for openstack
RUN zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Products/SLE-Module-Basesystem/15-SP1/x86_64/product/" basesystem_pool;\
    zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Products/SLE-Module-Containers/15-SP1/x86_64/product/" containers_pool;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Products/SLE-Module-Server-Applications/15-SP1/x86_64/product/" serverapps_pool;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Products/SLE-Product-SLES/15-SP1/x86_64/product/" sle_server_pool;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Updates/SLE-Module-Basesystem/15-SP1/x86_64/update/" basesystem_updates;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Updates/SLE-Module-Containers/15-SP1/x86_64/update/" containers_updates;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Updates/SLE-Module-Server-Applications/15-SP1/x86_64/update/" serverapps_updates;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE/Updates/SLE-Product-SLES/15-SP1/x86_64/update/" sle_server_updates;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE:/SLE-15-SP1:/GA/standard/" GA;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE:/SLE-15-SP1:/Update/standard/" GAUPdate;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE:/SLE-15-SP1:/Update:/Products:/CASP40/standard" Standard;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE:/SLE-15-SP1:/Update:/Products:/CASP40:/Update/standard" Update;\
	zypper ar --no-gpgcheck "http://download.suse.de/ibs/SUSE:/CA/SLE_15_SP1/SUSE:CA.repo"

RUN zypper refresh;\
	zypper dist-upgrade --auto-agree-with-licenses --no-confirm
## Deps for validator_caasp
RUN zypper in --auto-agree-with-licenses --no-confirm openssh sudo tar which curl python3-pip unzip
RUN zypper in --auto-agree-with-licenses --no-confirm helm jq libjq1 libonig4
## ca needed for openstack
RUN zypper in --auto-agree-with-licenses --no-confirm ca-certificates-attachmate ca-certificates-microfocus ca-certificates-suse

RUN zypper in --auto-agree-with-licenses --no-confirm skuba patterns-caasp-Management
RUN zypper clean -a

COPY sonobuoy /usr/local/bin/
COPY scripts /app
COPY run.sh /app

VOLUME ["/app/cluster"]
VOLUME ["/app/config"]
WORKDIR /app

ENTRYPOINT ["/app/run.sh"]
