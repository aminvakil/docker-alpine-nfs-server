#!/bin/bash

rm /etc/exports

# Check if the SHARED_DIRECTORY variable is empty
if [ -z "${SHARED_DIRECTORY}" ]; then
  echo "The SHARED_DIRECTORY environment variable is unset or null, exiting..."
  exit 1
else
  echo "Writing SHARED_DIRECTORY to /etc/exports file"
  echo "{{SHARED_DIRECTORY}} {{PERMITTED}}({{READ_ONLY}},fsid=0,{{SYNC}},no_subtree_check,no_auth_nlm,insecure,no_root_squash)" >> /etc/exports
  /bin/sed -i "s@{{SHARED_DIRECTORY}}@${SHARED_DIRECTORY}@g" /etc/exports
fi

# This is here to demonsrate how multiple directories can be shared. You
# would need a block like this for each extra share.
# Any additional shares MUST be subdirectories of the root directory specified
# by SHARED_DIRECTORY.

# Check if the SHARED_DIRECTORY_2 variable is empty
if [ ! -z "${SHARED_DIRECTORY_2}" ]; then
  echo "Writing SHARED_DIRECTORY_2 to /etc/exports file"
  echo "{{SHARED_DIRECTORY_2}} {{PERMITTED}}({{READ_ONLY}},{{SYNC}},no_subtree_check,no_auth_nlm,insecure,no_root_squash)" >> /etc/exports
  /bin/sed -i "s@{{SHARED_DIRECTORY_2}}@${SHARED_DIRECTORY_2}@g" /etc/exports
fi

# Check if the PERMITTED variable is empty
if [ -z "${PERMITTED}" ]; then
  echo "The PERMITTED environment variable is unset or null, defaulting to '*'."
  echo "This means any client can mount."
  /bin/sed -i "s/{{PERMITTED}}/*/g" /etc/exports
else
  echo "The PERMITTED environment variable is set."
  echo "The permitted clients are: ${PERMITTED}."
  /bin/sed -i "s/{{PERMITTED}}/"${PERMITTED}"/g" /etc/exports
fi

# Check if the READ_ONLY variable is set (rather than a null string) using parameter expansion
if [ -z ${READ_ONLY+y} ]; then
  echo "The READ_ONLY environment variable is unset or null, defaulting to 'rw'."
  echo "Clients have read/write access."
  /bin/sed -i "s/{{READ_ONLY}}/rw/g" /etc/exports
else
  echo "The READ_ONLY environment variable is set."
  echo "Clients will have read-only access."
  /bin/sed -i "s/{{READ_ONLY}}/ro/g" /etc/exports
fi

# Check if the SYNC variable is set (rather than a null string) using parameter expansion
if [ -z "${SYNC+y}" ]; then
  echo "The SYNC environment variable is unset or null, defaulting to 'async' mode".
  echo "Writes will not be immediately written to disk."
  /bin/sed -i "s/{{SYNC}}/async/g" /etc/exports
else
  echo "The SYNC environment variable is set, using 'sync' mode".
  echo "Writes will be immediately written to disk."
  /bin/sed -i "s/{{SYNC}}/sync/g" /etc/exports
fi