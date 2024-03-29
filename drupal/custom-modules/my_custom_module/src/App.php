<?php

namespace Drupal\my_custom_module;

use Drupal\my_custom_module\traits\Environment;
use Drupal\my_custom_module\traits\Singleton;

/**
 * Module-wide functionality.
 */
class App {

  use Singleton;
  use Environment;

  /**
   * Testable implementation of hook_cron().
   */
  public function hookCron() {
    // Just an example of where you'd implement testable hooks.
  }

}
