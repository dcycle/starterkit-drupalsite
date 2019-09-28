#!/bin/bash
#
# Assuming you have the latest version Docker installed, this script will
# fully create or update your environment.
#
set -e

export BASE="$(pwd)"

# See http://patorjk.com/software/taag/#p=display&f=Ivrit&t=D8%20Starterkit%0A
cat ./scripts/lib/my-ascii-art.txt

echo ''
echo 'About to try to get the latest version of'
echo 'https://hub.docker.com/r/dcycle/drupal/ from the Docker hub. This image'
echo 'is updated automatically every Wednesday with the latest version of'
echo 'Drupal and Drush. If the image has changed since the latest deployment,'
echo 'the environment will be completely rebuilt based on this image.'
docker pull dcycle/drupal:8drush9

echo ''
echo '-----'
echo 'Determining or creating mysql root password'
ENVFILELOCATION="$BASE/.env"
echo "Looking in $ENVFILELOCATION"
if [ -f "$ENVFILELOCATION" ]; then
  echo "$ENVFILELOCATION exists"
  echo "Looking for variable MYSQL_ROOT_PASSWORD in $ENVFILELOCATION"
  source "$ENVFILELOCATION"
  if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "MYSQL_ROOT_PASSWORD is not set in $ENVFILELOCATION"
  else
    echo "MYSQL_ROOT_PASSWORD is set; not showing here for security reasons"
  fi
else
  echo "$ENVFILELOCATION does not exist"
fi
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  PW=$(./scripts/uuid.sh)
  LINE="MYSQL_ROOT_PASSWORD=$PW"
  echo "$LINE" >> "$ENVFILELOCATION"
  echo "We entered a MySQL root password in $ENVFILELOCATION"
  source "$ENVFILELOCATION"
fi
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
  >&2 echo "Unexpected error: MYSQL_ROOT_PASSWORD does not exist"
  exit 1
fi

echo ''
echo '-----'
echo 'About to create the starterkit_drupal8site_default network if it does'
echo 'exist, because we need it to have a predictable name when we try to'
echo 'connect other containers to it (for example browser testers).'
echo 'The network is then referenced in docker-compose.yml.'
echo 'See https://github.com/docker/compose/issues/3736.'
docker network ls | grep starterkit_drupal8site_default || docker network create starterkit_drupal8site_default

echo ''
echo '---DETERMINE LOCAL DOMAIN---'
echo 'The local domain variable, used by https-deploy.sh does not need to be'
echo 'set during non-https deployment, however we will set it anyway because'
echo 'otherwise docker-compose up will complain that the variable is not set.'
source ./scripts/lib/set-local-domain.sh

echo ''
echo '-----'
echo 'About to start persistent (-d) containers based on the images defined'
echo 'in ./Dockerfile and ./docker-compose.yml. We are also telling'
echo 'docker-compose to rebuild the images if they are out of date.'
docker-compose up -d --build

echo ''
echo '-----'
echo 'Running the deploy script on the running containers. This installs'
echo 'Drupal if it is not yet installed.'
docker-compose exec drupal /scripts/deploy.sh

# If you need to do stuff after deployment such as set a state variable, do it
# here.

echo ''
echo '-----'
echo 'Running the update script on the container.'
docker-compose exec drupal /scripts/update.sh

echo ''
echo '-----'
echo ''
echo 'If all went well you can now access your site at:'
./scripts/uli.sh
echo '-----'
echo ''
echo 'You might want to visit /admin/reports/status and fix any problems.'
echo ''
