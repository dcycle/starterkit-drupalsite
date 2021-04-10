#
# Make sure we can build our pantheon code.
#

source ./scripts/pantheon/lib/load-config.source.sh

if [ -z "$PANTHEONGIT" ]; then
  >&2 echo "PANTHEONGIT must be in $VERSIONEDCONFIG or $UNVERSIONEDCONFIG"
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi
if [ -z "$PANTHEONSSHKEYNOPASSDIR" ]; then
  >&2 echo "PANTHEONSSHKEYNOPASSDIR must be in $VERSIONEDCONFIG or $UNVERSIONEDCONFIG"
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi
if [ -z "$PANTHEONSSHKEYNOPASSNAME" ]; then
  >&2 echo "PANTHEONSSHKEYNOPASSNAME must be in $VERSIONEDCONFIG or $UNVERSIONEDCONFIG"
  >&2 echo "See ./scripts/pantheon/README.md"
  exit 1
fi

echo "Making sure git is installed"
git version
echo "Making sure docker is installed"
docker -v

echo "Testing git repo to make sure we have access to it."
echo "If this fails make sure your ssh keys are in order and don't have passwords."
echo "You might want to have a key specific to pantheon."
ssh-agent bash -c "ssh-add $PANTHEONSSHKEY; git ls-remote $PANTHEONGIT" > /dev/null
