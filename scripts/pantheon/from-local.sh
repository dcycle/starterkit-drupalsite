#!/bin/bash
#
# Move database, code, private files and public files to an environment.
#
set -e

BASE="$PWD"
ENV="$1"
source "$BASE"/scripts/pantheon/lib/from-local-preflight.source.sh

echo "=> Exporting the following to the $ENV environment:"
echo "=> * Database"
echo "=> * Public files"
echo "=> * Code"

echo "=> "
echo "=> Step one, generate database"
./scripts/pantheon/generate-database-from-local-for-import.sh

echo "=> "
echo "=> Step two, generate files"
./scripts/pantheon/generate-files-from-local-for-import.sh

echo "=> "
echo "=> Step three, export code from local to Pantheon"
./scripts/pantheon/build.sh
