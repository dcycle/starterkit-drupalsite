#!/bin/bash
#
# Fast tests meant to be run locally.
#
set -e

echo "Linting"
./scripts/lint.sh
echo "Unit"
./scripts/unit.sh
