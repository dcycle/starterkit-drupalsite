# This file is meant to be sourced.
#
# One-time login link for this environment.
#
set -e

echo " => Dummy email client (see README): http://$(docker compose port mail 8025)"
echo " => View profiling results (see README): http://$(docker compose port profiling_visualizer 80)/webgrind"
