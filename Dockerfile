FROM busybox:1.32

LABEL maintainer="tobiasbp@gmail.com"

ENV FD_VERSION="1.3" \
    FD_ADMIN_UID="fd-admim" \
    FD_ADMIN_PASSWORD="fd-admim" \
    FD_BASE_DN="dc=example,dc=org" \
    FD_PASSWORD_MIN_LENGTH="16" \
    FD_TIMEZONE="Europe/Berlin"

# Add the FD schemas and the fd-config.ldif
COPY image/fd-${FD_VERSION}  /var/local/ldap/fusiondirectory

# Add script to update ldif
COPY image/update_ldif.sh /usr/bin/

# Update the ldif file with data in env vars
CMD ["update_ldif.sh"]
