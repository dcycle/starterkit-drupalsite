FROM dcycle/drupal:8

# Make sure opcache is disabled during development so that our changes
# to PHP are reflected immediately.
RUN echo 'opcache.enable=0' >> /usr/local/etc/php/php.ini

# Download contrib modules
RUN drush dl devel -y
# Group fields nicely for site editors
RUN drush dl field_group
RUN drush dl token
RUN drush dl metatag
RUN drush dl ctools
RUN drush dl pathauto
# Contribute is a dependency of webform.
RUN drush dl contribute
RUN drush dl webform
# Paragraphs and its dependency, entity_reference_revisions, replace
# field collections.
RUN drush dl paragraphs
RUN drush dl entity_reference_revisions
# Masquerade makes it easier to debug what a client (editor) is actually
# seeing.
RUN drush dl masquerade

# The bootstrap theme
RUN drush dl bootstrap

# Example of how to apply a patch.
# RUN curl -O https://www.drupal.org/files/issues/2752961-114.patch
# RUN patch -p1 < 2752961-114.patch
# RUN rm 2752961-114.patch

# Add some files to our container. See each individual file for details.
ADD drupal/settings/settings.php /var/www/html/sites/default/settings.php
ADD drupal/settings/services.yml /var/www/html/sites/default/services.yml

# Avoid memory limits with large database imports.
RUN echo 'memory_limit = 512M' >> /usr/local/etc/php/php.ini

RUN apt-get -y install rsyslog
RUN echo 'local0.* /var/log/drupal.log' >> /etc/rsyslog.conf

# Avoid memory limits with large database imports.
RUN echo 'upload_max_filesize = 25M' >> /usr/local/etc/php/php.ini
RUN echo 'post_max_size = 25M' >> /usr/local/etc/php/php.ini

# During local development, fetch files from the stage site if they do not
# exist locally.
RUN drush dl stage_file_proxy

# We are trying to emulate Acquia's server setup as much as possible. In
# Acquia's system, local settings are at /var/www/site-php...
# So local-settings.php serves is never deployed to Acquia. There,
# starterkit-drupal8site-settings.inc is used instead.
ADD drupal/settings/local-settings.php /var/www/site-php/starterkit-drupal8site/starterkit-drupal8site-settings.inc

# Mail should be sent to a dummy mail interface, see ./README.md for details.
RUN drush dl smtp

EXPOSE 80
