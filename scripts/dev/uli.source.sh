# This file is meant to be sourced.
#
# One-time login link for this environment.
#
set -e

echo " => Dummy email client (see README): http://$(./scripts/docker-compose-port.sh mail 8025)"
echo " => View profiling results (see README): http://$(./scripts/docker-compose-port.sh profiling_visualizer 80)/webgrind"
