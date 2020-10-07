#!/bin/sh


SRC=/tmp/fd
DEST=/var/fd

# Create the destination dir
mkdir -p ${DEST}

# Copy the fd files (The user could have mounted a volume here)
cp -r ${SRC}/* ${DEST}

# The ldif to update
LDIF=${DEST}/ldif/fd-config.ldif

# Encrypt the password
FD_ADMIN_PASSWORD_ENCRYPTED=`echo "${FD_ADMIN_PASSWORD}" | mkpasswd -m sha512crypt --stdin`

# Create hashes for assignment of rights for admin
DN_ROLE_ADMIN_BASE64=`echo -n "cn=admin,ou=aclroles,ou=fd,${FD_BASE_DN}" | base64`
DN_USER_ADMIN_BASE64=`echo -n "uid=${FD_ADMIN_UID},ou=fd,${FD_BASE_DN}" | base64`


# Set base DN
sed -i "s|{{ FD_BASE_DN }}|${FD_BASE_DN}|g" ${LDIF}

# Set encrypted admin password in ldif
sed -i "s|{{ FD_ADMIN_PASSWORD }}|\{crypt\}${FD_ADMIN_PASSWORD_ENCRYPTED}|g" ${LDIF}

# Set admins UID
sed -i "s|{{ FD_ADMIN_UID }}|${FD_ADMIN_UID}|g" ${LDIF}

# Set minimum password length
sed -i "s|{{ FD_PASSWORD_MIN_LENGTH }}|${FD_PASSWORD_MIN_LENGTH}|g" ${LDIF}

# Set timezone
sed -i "s|{{ FD_TIMEZONE }}|${FD_TIMEZONE}|g" ${LDIF}

# Assign rights to admin user
sed -i "s|{{ DN_ROLE_ADMIN_BASE64 }}|${DN_ROLE_ADMIN_BASE64}|g" ${LDIF}
sed -i "s|{{ DN_USER_ADMIN_BASE64 }}|${DN_USER_ADMIN_BASE64}|g" ${LDIF}

# Remove file rfc2307bis.schema
if [ ${FD_INCLUDE_RFC2307BIS} == "false" ]; then
  rm -v ${DEST}/schema/core/rfc2307bis.schema
fi

find ${DEST}
