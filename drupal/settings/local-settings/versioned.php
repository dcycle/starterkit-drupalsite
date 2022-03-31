<?php

$databases['default']['default'] = [
  'database' => 'drupal',
  'username' => 'root',
  'password' => getenv('MYSQL_ROOT_PASSWORD'),
  'host' => 'mysql',
  'port' => '3306',
  'driver' => 'mysql',
  'prefix' => '',
  'collation' => 'utf8mb4_general_ci',
];

$settings['hash_salt'] = getenv('HASH_SALT');

// Override config, see
// https://www.drupal.org/docs/8/api/configuration-api/configuration-override-system
// We are using stage_file_proxy to fetch files from the staging D8
// environment rather than import them for local development.
$config['stage_file_proxy.settings']['origin'] = 'http://Appstg.prod.acquia-sites.com';

// See https://www.drupal.org/project/smtp/issues/3003639. Overriding
// smtp_on = TRUE has no effect, but I'm setting it anyway so if someone
// visits the GUI at http://0.0.0.0:32778/admin/config/system/smtp they
// will see that SMTP is on in the settings file. What actually causes this
// to work is the line setting the mail interface to SMTPMailSystem.
$config['smtp.settings']['smtp_on'] = TRUE;
// 'mail' is the name of the dummy mailserver defined in docker-compose.yml.
$config['smtp.settings']['smtp_host'] = 'mail';
$config['smtp.settings']['smtp_port'] = 1025;
$config['system.mail']['interface']['default'] = 'SMTPMailSystem';
$config['system.logging']['error_level'] = 'verbose';

$settings['file_private_path'] = '/drupal-private-files';

$config['system.performance']['css']['preprocess'] = FALSE;
$config['system.performance']['js']['preprocess'] = FALSE;

$settings['trusted_host_patterns'] = [
  '^localhost$',
  '127\.0\.0\.1',
  '0\.0\.0\.0',
];
