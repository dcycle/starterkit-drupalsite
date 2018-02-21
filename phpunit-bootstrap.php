<?php

/**
 * @file
 * PHPUnit bootstrap: our bare-bones version of Drupal.
 *
 * PHPUnit knows nothing about Drupal, so provide PHPUnit with the bare
 * minimum it needs to know in order to test classes which use Drupal
 * core and contrib classes.
 *
 * Used by the PHPUnit test runner and referenced in ./phpunit-autoload.xml.
 */

namespace Drupal\Core\Form{
  class FormBase {}
  class FormStateInterface {}
}
