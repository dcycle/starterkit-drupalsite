#!/bin/bash
#
# Make sure image styles get properly generated.
#
set -e

DOMAIN=$(docker-compose port webserver 80)

echo ""
for path in "sites/default/files/2022-03/kittens01.jpg" "sites/default/files/styles/large/public/2022-03/kittens01.jpg"; do
  echo ""
  URL="http://$DOMAIN/$path"
  echo "Make sure $URL exists."
  curl -f -I "$URL"
  echo "$URL exists."
  echo ""
done

echo "Image styles seem to work properly."
echo ""
