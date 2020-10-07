FROM busybox:1.32

LABEL maintainer="tobiasbp@gmail.com"

ENV FD_VERSION="1.3" \
    FD_ADMIN_UID="fd-admin" \
    FD_ADMIN_PASSWORD="fd-admin" \
    FD_BASE_DN="dc=example,dc=org" \
    FD_PASSWORD_MIN_LENGTH="16" \
    FD_TIMEZONE="Europe/Berlin" \
    FD_INCLUDE_RFC2307BIS="false"

# Add the fd files to the image
COPY image/fd-${FD_VERSION} /tmp/fd

# Add the shell script which processes the files
COPY image/update_ldif.sh /usr/bin/

# Update the ldif file with data in env vars when image us run
CMD ["update_ldif.sh"]
