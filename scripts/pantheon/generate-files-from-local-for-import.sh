#!/bin/bash
#
# Generate files for import in Pantheon.
#
set -e

BASE="$PWD"
cd ./drupal/starter-data
rm -f files.tar.gz
tar czvf files.tar.gz files
cd "$BASE"
rm -rf ./do-not-commit/to-import-in-pantheon/files.tar.gz
mkdir -p ./do-not-commit/to-import-in-pantheon
mv ./drupal/starter-data/files.tar.gz ./do-not-commit/to-import-in-pantheon/files.tar.gz

echo "=> Log into pantheon and import the files:"
echo "=> ./do-not-commit/to-import-in-pantheon/files.tar.gz"
read -p "Press enter to continue"
rm -f ./do-not-commit/to-import-in-pantheon/files.tar.gz
echo "=> All done!"
