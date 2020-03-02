# This file is meant to be sourced.
#
# Make sure we can run a docker-compose command.
#
set -e

ENVFILELOCATION=./.env
if [ -f "$ENVFILELOCATION" ]; then
  >&2 echo "Cannot call ./scripts/create-env.source.sh if $ENVFILELOCATION exists."
  exit 1
fi
cp "./scripts/$TARGET_ENV/env.txt" "$ENVFILELOCATION"
{
  echo "MYSQL_ROOT_PASSWORD=$(./scripts/uuid.sh)"
  echo "HASH_SALT=$(./scripts/uuid.sh)"
}  >> "$ENVFILELOCATION"
