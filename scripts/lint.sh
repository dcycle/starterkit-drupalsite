set -e

echo 'Linting PHP files'
echo 'If you are getting a false negative, use:'
echo ''
echo '// @codingStandardsIgnoreStart'
echo '...'
echo '// @codingStandardsIgnoreEnd'
echo ''

docker run -v "$(pwd)"/drupal/custom-modules:/code dcycle/php-lint --standard=DrupalPractice /code
docker run -v "$(pwd)"/drupal/custom-modules:/code dcycle/php-lint --standard=Drupal /code
echo 'Linting shell scripts'
docker run -v "$(pwd)":/code dcycle/shell-lint ./scripts/lint.sh
docker run -v "$(pwd)":/code dcycle/shell-lint ./scripts/https-deploy.sh
