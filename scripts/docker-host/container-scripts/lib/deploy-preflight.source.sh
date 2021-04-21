#
# Preflight for initial setup.
#

BASE="$(pwd)"

if [ -z "$ENV" ]; then
  >&2 echo "Please export ENV=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "ENV is $ENV"

if [ -z "$DEPLOYKEY" ]; then
  >&2 echo "Please export DEPLOYKEY=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "DEPLOYKEY is $DEPLOYKEY"

if [ -z "$GITREPO" ]; then
  >&2 echo "Please export GITREPO=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "GITREPO is $GITREPO"

if [ -z "$DOCKERHOSTPARENTDIR" ]; then
  >&2 echo "Please export DOCKERHOSTPARENTDIR=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "DOCKERHOSTPARENTDIR is $DOCKERHOSTPARENTDIR"

if [ -z "$DOCKERHOSTDOMAIN" ]; then
  >&2 echo "Please export DOCKERHOSTDOMAIN=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "DOCKERHOSTDOMAIN is $DOCKERHOSTDOMAIN"

if [ -z "$DOCKERPREVHOSTDOMAIN" ]; then
  >&2 echo "Please export DOCKERPREVHOSTDOMAIN=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "DOCKERPREVHOSTDOMAIN is $DOCKERPREVHOSTDOMAIN"

if [ -z "$DOCKERNETWORK" ]; then
  >&2 echo "Please export DOCKERNETWORK=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "DOCKERNETWORK is $DOCKERNETWORK"

if [ -z "$DOCKERHOSTDIR" ]; then
  >&2 echo "Please export DOCKERHOSTDIR=...; see ./scripts/docker-host/README.md"
  exit 1
fi
echo "DOCKERHOSTDIR is $DOCKERHOSTDIR"

DOCKERHOSTFULLDIR="$DOCKERHOSTPARENTDIR/$DOCKERHOSTDIR"

echo "=> Checking if local computer has access to $GITREPO with $DEPLOYKEY"

ssh-agent bash -c "ssh-add $DEPLOYKEY; git ls-remote $GITREPO"

echo "Preflight on local OK."
