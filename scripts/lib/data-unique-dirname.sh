#!/bin/bash
#
# Print a unique filename, like 2020-01-01-1234567.sql, for a database dump.
#
set -e

# See https://stackoverflow.com/a/1401502/1207752
FILENAME="$(date +%F)-$RANDOM"
echo $FILENAME
