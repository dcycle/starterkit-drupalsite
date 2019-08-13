FROM dcycle/drupal:8drush9

# Make sure opcache is disabled during development so that our changes
# to PHP are reflected immediately.
RUN echo 'opcache.enable=0' >> /usr/local/etc/php/php.ini

# Download contrib modules
# stage_file_proxy: During local development, fetch files from the stage site
# if they do not.
# smtp: Mail should be sent to a dummy mail interface, see ./README.md for
# details.
RUN composer require \
  drupal/devel \
  drupal/field_group \
  drupal/token \
  drupal/metatag \
  drupal/pathauto \
  drupal/webform \
  drupal/paragraphs \
  drupal/masquerade \
  drupal/bootstrap \
  drupal/stage_file_proxy \
  drupal/smtp

# Example of how to apply a patch.
# RUN curl -O https://www.drupal.org/files/issues/2752961-114.patch
# RUN patch -p1 < 2752961-114.patch
# RUN rm 2752961-114.patch

# Add some files to our container. See each individual file for details.
ADD drupal/settings/settings.php /var/www/html/sites/default/settings.php
ADD drupal/settings/services.yml /var/www/html/sites/default/services.yml

# Avoid memory limits with large database imports.
RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/php.ini

RUN apt-get -y update && \
  apt-get -y install rsyslog
RUN echo 'local0.* /var/log/drupal.log' >> /etc/rsyslog.conf

# Avoid memory limits with large database imports.
RUN echo 'upload_max_filesize = 25M' >> /usr/local/etc/php/php.ini
RUN echo 'post_max_size = 25M' >> /usr/local/etc/php/php.ini

# We are trying to emulate Acquia's server setup as much as possible. In
# Acquia's system, local settings are at /var/www/site-php...
# So local-settings.php serves is never deployed to Acquia. There,
# starterkit-drupal8site-settings.inc is used instead.
ADD drupal/settings/local-settings.php /var/www/site-php/starterkit-drupal8site/starterkit-drupal8site-settings.inc

EXPOSE 80
