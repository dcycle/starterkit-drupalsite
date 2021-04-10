#
# Load our config file.
#

VERSIONEDCONFIG="$(pwd)"/config/versioned.source.sh
UNVERSIONEDCONFIG="$(pwd)"/config/unversioned.source.sh
if [ -f "$VERSIONEDCONFIG" ]; then
  source "$VERSIONEDCONFIG"
fi
if [ -f "$UNVERSIONEDCONFIG" ]; then
  source "$UNVERSIONEDCONFIG"
fi
PANTHEONSSHKEY="$PANTHEONSSHKEYNOPASSDIR/$PANTHEONSSHKEYNOPASSNAME"
