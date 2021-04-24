#!/bin/bash
#
# Fast tests which can be run locally or on a continuous integration server.
#
set -e

echo ""
echo " => Starting fast tests."
echo ""
echo "PHP linting"
./scripts/lint.sh
echo "PHP unit tests"
./scripts/unit.sh
echo "Javascript linting"
./scripts/lint-js.sh
echo "Javascript unit tests"
./scripts/unit-js.sh
echo "Static analysis"
./scripts/static.sh
echo ""
echo " => Done with fast tests."
echo ""
