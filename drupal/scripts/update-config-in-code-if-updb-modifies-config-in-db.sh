#!/bin/bash
#
# See "hook_update_N() and configuration" in ./README.md.
#
set -e

echo ""
echo "Change our code to reflect modifications made by hook_update_N()s. See"
echo "https://www.drupal.org/project/drupal/issues/3110362 and"
echo "the section 'hook_update_N() and configuration' in ./README.md."
drush config:import -y
drush updb -y
drush config:export -y
