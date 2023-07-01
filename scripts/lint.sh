#!/bin/bash
#
# Linting.
#
set -e

echo 'Linting PHP files with https://github.com/dcycle/docker-php-lint'
echo 'If you are getting a false positive, use:'
echo ''
echo '// @codingStandardsIgnoreStart'
echo '...'
echo '// @codingStandardsIgnoreEnd'
echo ''
echo 'To automatically fix errors, you can run:'
echo ''
echo './scripts/lint-php-fix.sh'
echo ''

docker run --rm -v \
  "$(pwd)"/drupal/custom-modules:/code \
  dcycle/php-lint:3 --standard=DrupalPractice /code
docker run --rm -v \
  "$(pwd)"/drupal/custom-modules:/code \
  dcycle/php-lint:3 --standard=Drupal /code

echo 'Linting shell scripts'

docker run --rm -v "$(pwd)":/code dcycle/shell-lint ./scripts/lint.sh
docker run --rm -v "$(pwd)":/code dcycle/shell-lint ./scripts/https-deploy.sh
