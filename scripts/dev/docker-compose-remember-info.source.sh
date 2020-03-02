#
# Remember environment-specific docker-compose info.
# Meant for use with source ...
#
set -e

CONTAINER_MAIL=$(echo "$RESULT" | grep mail | grep -o '^[-a-zA-Z0-9_]*')
{
  echo CONTAINER_MAIL="$CONTAINER_MAIL"
} >> ./.docker-compose-info
