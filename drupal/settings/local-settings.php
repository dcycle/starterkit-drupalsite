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

$settings['hash_salt'] = 'whatever';

// Override config, see
// https://www.drupal.org/docs/8/api/configuration-api/configuration-override-system
// We are using stage_file_proxy to fetch files from the staging D8
// environment rather than import them for local development.
$config['stage_file_proxy.settings']['origin'] = 'http://Appstg.prod.acquia-sites.com';
