#
# Load our config information.
#

source ./scripts/lib/load-config.source.sh

if [ -z "$ACQUIAGIT" ]; then
  >&2 echo "Please make sure ACQUIAGIT exists in yoyur versioned or unversioned ./config/* file. It should look something like this:"
  >&2 echo ""
  >&2 echo "ACQUIAGIT=/full/path/to/acquia/git/on/local/computer"
  >&2 echo ""
  exit 1
fi
if [ "$ACQUIAGIT" == "/full/path/to/acquia/git/on/local/computer" ]; then
  >&2 echo "In your ./config file, please make sure ACQUIAGIT, whose value is currently /full/path/to/acquia/git/on/local/computer, is the actual local path of the Acquia git repo on your local computer."
  exit 1
fi
if [ ! -d "$ACQUIAGIT"/.git ]; then
  >&2 echo "$ACQUIAGIT/.git does not exist, please make sure it exists on your computer"
  exit 1
fi
if [ -z "$ACQUIA_MULTISITE_ID" ]; then
  >&2 echo "Please make sure ACQUIA_MULTISITE_ID exists in yoyur versioned or unversioned ./config/* file. It should look something like this:"
  >&2 echo ""
  >&2 echo "ACQUIA_MULTISITE_ID=default"
  >&2 echo ""
  exit 1
fi
if [ -z "$ACQUIA_CONFIG_DIR" ]; then
  >&2 echo "Please make sure ACQUIA_CONFIG_DIR exists in yoyur versioned or unversioned ./config/* file. It should look something like this:"
  >&2 echo ""
  >&2 echo "ACQUIA_CONFIG_DIR=config"
  >&2 echo ""
  >&2 echo "or"
  >&2 echo ""
  >&2 echo "ACQUIA_CONFIG_DIR=config-my-multisite-id"
  >&2 echo ""
  exit 1
fi
echo "ACQUIAGIT=$ACQUIAGIT"
echo "ACQUIA_MULTISITE_ID=$ACQUIA_MULTISITE_ID"
echo "ACQUIA_CONFIG_DIR=$ACQUIA_CONFIG_DIR"
