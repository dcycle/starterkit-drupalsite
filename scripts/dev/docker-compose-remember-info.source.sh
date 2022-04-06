#
# Remember environment-specific docker-compose info.
# Meant for use with source ...
#
set -e

CONTAINER_MAIL=$(./scripts/docker-compose.sh ps -q mail)
{
  echo CONTAINER_MAIL="$CONTAINER_MAIL"
} >> ./.docker-compose-info
CONTAINER_PROFILING_VISUALIZER=$(./scripts/docker-compose.sh ps -q profiling_visualizer)
{
  echo CONTAINER_PROFILING_VISUALIZER="$CONTAINER_PROFILING_VISUALIZER"
} >> ./.docker-compose-info
