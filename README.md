

# fusiondirectory-schemas-ldif
A utility Docker image for preparing schema and ldif files to initialize an
LDAP database for use with [FusionDirectory](https://www.fusiondirectory.org/) version [1.3](https://fusiondirectory-user-manual.readthedocs.io/en/1.3/index.html).

# Usage
The schema files are stored in _/var/local/ldap/fusiondirectory/schema_,
and the .ldif file(s) in _/var/local/ldap/fusiondirectory/ldif_.

This image has been tested with Docker image [osixia/docker-openldap](https://github.com/osixia/docker-openldap)
which is able to read schema and ldif files when the container is run the first time.

Make your schema files available to _osixia/docker-openldap_ by mounting them here: 
`/container/service/slapd/assets/config/bootstrap/schema/fd-schema`

Make your ldif file(s) available to _osixia/docker-openldap_ by mounting them here: 
`/container/service/slapd/assets/config/bootstrap/ldif/fd-ldif`

If you are using Kubernetes, you can run this image as an [Init Container](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
together with [osixia/docker-openldap](https://github.com/osixia/docker-openldap) when configuring an LDAP backend for FusionDirectory.


# Configuration
Configure the generated ldif file(s) by setting the following environment variables.
The following shows the defaults for the variables.

* FD_VERSION="1.3"
* FD_ADMIN_UID="fd-admim"
* FD_ADMIN_PASSWORD="fd-admim"
* FD_BASE_DN="dc=example,dc=org"
* FD_PASSWORD_MIN_LENGTH="16"
* FD_TIMEZONE="Europe/Berlin"

The only supported version of FusionDirectory is 1.3.

