#!/bin/bash
#
# SSH into a running container.
#
set -e

echo ""
echo "About to try to SSH into a running local Drupal container. If you get an"
echo "error, consider running ./scripts/deploy.sh to make sure you have a"
echo "local environment ready."
echo ""
./scripts/docker-compose.sh exec drupal /bin/bash
echo ""
echo "You just logged out of your running local Drupal container. To log back"
echo "in, run ./scripts/ssh.sh"
echo ""
