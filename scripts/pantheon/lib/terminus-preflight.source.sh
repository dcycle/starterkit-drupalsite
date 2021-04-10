#
# Make sure we can build our pantheon code.
#

source ./scripts/pantheon/lib/load-config.source.sh

if [ -z "$PANTHEONSSHKEY" ]; then
  >&2 echo "PANTHEONSSHKEY must be in $CONFIG"
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi
if [ -z "$PANTHEONTOKEN" ]; then
  >&2 echo "PANTHEONTOKEN must be in $CONFIG"
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi

docker -v > /dev/null || { echo 'You need to have Docker installed to use ./scripts/panthon/drush.sh'; exit 1; }
