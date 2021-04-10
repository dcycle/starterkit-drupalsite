#
# Make sure we can build our pantheon code.
#

source ./scripts/pantheon/lib/terminus-preflight.source.sh

if [ -z "$ENV" ]; then
  >&2 echo "Pass env as your first argument."
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi
if [ -z "$PANTHEONSITENAME" ]; then
  >&2 echo "PANTHEONSITENAME must be in $VERSIONEDCONFIG or $UNVERSIONEDCONFIG"
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi
