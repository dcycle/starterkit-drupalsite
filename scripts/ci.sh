#!/bin/bash
#
# Tests meant to be run on Circle CI.
#
set -e

echo "Fast tests and linting"
./scripts/test.sh
echo "Test initial deployment"
./scripts/deploy.sh
echo "Test incremental deployment"
./scripts/deploy.sh
echo "Test exporting config"
./scripts/export-config.sh
echo "Test update starter data"
./scripts/update-starter-data.sh
echo "Test running environment"
./scripts/test-running-environment.sh
echo "End-to-end tests"
./scripts/end-to-end-tests.sh
echo "Accessibility tests"
./scripts/a11y-tests.sh
BACKUPID="$(./scripts/lib/data-unique-dirname.sh)"
echo "Export test to $BACKUPID"
./scripts/create-data-backup.sh
echo "Import test to $BACKUPID"
./scripts/from-data-backup.sh "$BACKUPID"
