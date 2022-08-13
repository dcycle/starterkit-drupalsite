#
# Load our config file.
#

if [ -z "$CONFIGDIR" ]; then
  MYCONFIGDIR="./config"
else
  MYCONFIGDIR="$CONFIGDIR"
fi

VERSIONEDCONFIG="$(pwd)"/"$MYCONFIGDIR"/versioned.source.sh
UNVERSIONEDCONFIG="$(pwd)"/"$MYCONFIGDIR"/unversioned.source.sh

echo "Checking in $(pwd)/$MYCONFIGDIR"

if [ -f "$VERSIONEDCONFIG" ]; then
  source "$VERSIONEDCONFIG"
fi
if [ -f "$UNVERSIONEDCONFIG" ]; then
  source "$UNVERSIONEDCONFIG"
fi
