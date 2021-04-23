<?php

/**
 * If you need environment-specific settings, for example API keys, which
 * you do not want in git, you can create a file called
 * ./drupal/settings/local-settings/unversioned.php based on this file; it
 * will be loaded automatically.
 */

// This is an example.
$config['my-super-secret-api-key'] = 'princess';

// Example to override the dummy mail client with your own SMTP server, in
// this example gmail.
$config['smtp.settings']['smtp_host'] = 'smtp.gmail.com';
$config['smtp.settings']['smtp_port'] = 465;
$config['smtp.settings']['smtp_username'] = 'YOUR_NAME@gmail.com';
$config['smtp.settings']['smtp_password'] = 'YOUR_PASSWORD';
$config['smtp.settings']['smtp_protocol'] = 'ssl';
