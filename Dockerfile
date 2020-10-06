FROM ubuntu:20.04

LABEL maintainer="tobiasbp@gmail.com"

ENV FD_VERSION="1.3" \
    S2L_VERSION="1.3"

RUN apt-get update && apt-get -qqy upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -qqy install schema2ldif wget && \
    #apt-get -qqy install wget && \
    mkdir -p /usr/share/schemas/schema/core /usr/share/schemas/schema/plugins && \
    mkdir -p /usr/share/schemas/ldif/core /usr/share/schemas/ldif/plugins && \
    cd /tmp && \
    # Cores schemas (Included in FusionDirectory)
    wget --quiet https://repos.fusiondirectory.org/sources/fusiondirectory/fusiondirectory-${FD_VERSION}.tar.gz && \
    tar -xzf fusiondirectory-${FD_VERSION}.tar.gz --directory /usr/share/schemas/schema/core --wildcards --no-anchored "*.schema" --transform="s|.*/||" && \
    # Plugin schemas 
    wget --quiet https://repos.fusiondirectory.org/sources/fusiondirectory/fusiondirectory-plugins-${FD_VERSION}.tar.gz && \
    tar -xzf fusiondirectory-plugins-${FD_VERSION}.tar.gz --directory /usr/share/schemas/schema/plugins --wildcards --no-anchored "*.schema" --transform="s|.*/||" && \
    # Convert schema files to ldif
    for FILE in /usr/share/schemas/schema/core/*.schema; do F=`basename ${FILE%%.*}`; schema2ldif "${FILE}" >> "/usr/share/schemas/ldif/core/${F}.ldif"; done; \
    for FILE in /usr/share/schemas/schema/plugins/*.schema; do F=`basename ${FILE%%.*}`; schema2ldif "${FILE}" >> "/usr/share/schemas/ldif/plugins/${F}.ldif"; done; \
    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["find", "/usr/share/schemas"]

# FIXME: Why not install ldap-schema-manager too (Why not with ldaptools and a shel script), so schemas can be installed via LDAP
