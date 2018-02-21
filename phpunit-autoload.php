<?php

/**
 * @file
 * PHPUnit class autoloader.
 *
 * PHPUnit knows nothing about Drupal, so provide PHPUnit with the bare
 * minimum it needs to know in order to find classes by namespace.
 *
 * Used by the PHPUnit test runner and referenced in ./phpunit.xml.
 */

spl_autoload_register(function ($class) {
  $custom_code = [
    'my_custom_module' => 'drupal/custom-modules/my_custom_module',
  ];

  require_once 'phpunit-bootstrap.php';

  foreach ($custom_code as $namespace => $dir) {
    if (substr($class, 0, strlen('Drupal\\' . $namespace . '\\')) == 'Drupal\\' . $namespace . '\\') {
      $class2 = preg_replace('/^Drupal\\\\' . $namespace . '\\\\/', '', $class);
      $path = $dir . '/src/' . str_replace('\\', '/', $class2) . '.php';
      require_once $path;
    }
  }
});
