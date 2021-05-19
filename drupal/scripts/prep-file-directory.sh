#!/bin/bash
#
# Make sure a file directory (public or private) is ready for use.
#
set -e

if [ -z "$1" ]; then
  >&2 echo "Please call this with an argument such as /var/www/html/sites/default/files or /drupal-private-files"
  exit 1
fi

mkdir -p "$1"
chown -R www-data:www-data "$1"

if [ "$2" ]; then
  cp "$2" "$1"/.htaccess
fi
