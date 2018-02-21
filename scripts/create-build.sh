#!/bin/bash
#
# Some environments such as Acquia require the entire codebase to be in their
# git repo. We do not include items such as downloaded modules in our git
# repo by design. Therefore we need to create builds.
#
set -e

if [ -z "$TARGETDIRECTORY" ]; then
  >&2 echo 'Please export TARGETDIRECTORY=/path/to/dir before running';
  exit 1;
fi

BUILD="$RANDOM"
TARGET="$TARGETDIRECTORY/$BUILD"

echo "About to build the code in $TARGET"

docker cp $(cd "$D8" && docker-compose ps -q drupal):/var/www/config "$TARGET"/config
docker cp $(cd "$D8" && docker-compose ps -q drupal):/var/www/html "$TARGET"/docroot
