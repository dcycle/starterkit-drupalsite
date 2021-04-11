#
# Preflight for initial setup.
#

BASE="$(pwd)"

if [ -z "$ENV" ]; then
  >&2 echo "Please export ENV=...; see ./scripts/docker-host/README.md"
  exit 1
fi

CANDIDATE="$BASE/config/docker-host/$ENV/versioned.source.sh"

if [ ! -f "$CANDIDATE" ]; then
  >&2 echo "$CANDIDATE must exists; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "Sourcing $CANDIDATE"
source "$CANDIDATE"

CANDIDATE="$BASE/config/docker-host/$ENV/unversioned.source.sh"

if [ ! -f "$CANDIDATE" ]; then
  >&2 echo "$CANDIDATE must exists; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "Sourcing $CANDIDATE"
source "$CANDIDATE"

if [ -z "$DOCKERHOSTUSER" ]; then
  >&2 echo "DOCKERHOSTUSER must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERHOSTIP" ]; then
  >&2 echo "DOCKERHOSTIP must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERHOSTDOMAIN" ]; then
  >&2 echo "DOCKERHOSTDOMAIN must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERNETWORK" ]; then
  >&2 echo "DOCKERNETWORK must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERHOSTKEYNOPASSDIR" ]; then
  >&2 echo "DOCKERHOSTKEYNOPASSDIR must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERHOSTKEYNOPASSNAME" ]; then
  >&2 echo "DOCKERHOSTKEYNOPASSNAME must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DEPLOYKEYNOPASSDIR" ]; then
  >&2 echo "DEPLOYKEYNOPASSDIR must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DEPLOYKEYNOPASSNAME" ]; then
  >&2 echo "DEPLOYKEYNOPASSNAME must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$GITREPO" ]; then
  >&2 echo "GITREPO must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$GITBRANCH" ]; then
  >&2 echo "GITBRANCH must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERHOSTDIR" ]; then
  >&2 echo "DOCKERHOSTDIR must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

if [ -z "$DOCKERHOSTPARENTDIR" ]; then
  >&2 echo "DOCKERHOSTPARENTDIR must be defined in config; see ./scripts/docker-host/README.md"
  exit 1
fi

LOCALKEY="$DOCKERHOSTKEYNOPASSDIR/$DOCKERHOSTKEYNOPASSNAME"
DEPLOYKEY="$DEPLOYKEYNOPASSDIR/$DEPLOYKEYNOPASSNAME"

echo "=> Checking if local computer has access to $DOCKERHOSTUSER@$DOCKERHOSTIP with $LOCALKEY"

ssh-agent bash -c "ssh-add $LOCALKEY; ssh $DOCKERHOSTUSER@$DOCKERHOSTIP 'echo it works!'"

echo "Preflight on local OK."
