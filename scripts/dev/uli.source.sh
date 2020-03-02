# This file is meant to be sourced.
#
# One-time login link for this environment.
#
set -e

echo " => Dummy email client: http://$(./scripts/docker-compose-port.sh mail 8025)"
