#!/bin/bash
#
# Build the Drupal image.
#
# Instead of running individual RUN commands in the Dockerfiles, we are using
# this technique because previously, we could make one image (dev) build
# FROM another, but this is no longer automatic in case of mixed platforms (m1,
# intel) without using FROM ... --platform = ..., which works on mac OS on m1,
# but not on CircleCI. Therefore, instead of making one image build FROM
# another, we are running this script in all images.
#
set -e

# Download contrib modules
# stage_file_proxy: During local development, fetch files from the stage site
# if they do not.
# smtp: Mail should be sent to a dummy mail interface, see ./README.md for
# details.
# See https://getcomposer.org/doc/articles/troubleshooting.md#memory-limit-errors
composer require \
  drupal/email_registration \
  drupal/devel \
  drupal/field_group \
  drupal/token \
  drupal/metatag \
  drupal/pathauto \
  drupal/webform:^6 \
  drupal/paragraphs \
  drupal/masquerade \
  drupal/bootstrap \
  drupal/stage_file_proxy \
  drupal/smtp

# Example of how to apply a patch.
# curl -O https://www.drupal.org/files/issues/2752961-114.patch
# patch -p1 < 2752961-114.patch
# rm 2752961-114.patch

# Copy our contrib sites and themes to a non-shared space in the container.
# This is because if we are deploying to an already-existing environment,
# composer requiring something might put in modules/contrib/*, but
# modules/contrib/* is a shared volume between the PHP-FPM container and the
# Nginx container (it has to be, see "PHP and Apache (or Nginx) in separate
# Docker containers using Docker Compose", March 25, 2022, Dcycle Blog at
# https://blog.dcycle.com/blog/2022-03-25/php-apache-different-containers/).
# Putting the latest versions of modules/contrib and themes/contrib in
# /drupal-modules-contrib and /drupal-themes-contrib allows the update script
# at
rm -rf /drupal-modules-contrib /drupal-themes-contrib
cp -r modules/contrib /drupal-modules-contrib
cp -r themes/contrib /drupal-themes-contrib

# Avoid memory limits with large database imports.
echo 'memory_limit = 512M' >> /usr/local/etc/php/php.ini

# Avoid memory limits with large database imports.
echo 'upload_max_filesize = 25M' >> /usr/local/etc/php/php.ini
echo 'post_max_size = 25M' >> /usr/local/etc/php/php.ini
