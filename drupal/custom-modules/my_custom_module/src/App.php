<?php

namespace Drupal\my_custom_module;

use Drupal\my_custom_module\traits\Singleton;
use Drupal\my_custom_module\traits\Environment;

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

  public function someFunction() {
    $this->anotherFunction(5);
  }

  public function anotherFunction($int) {
    if ($int <= 0) {
      return;
    }
    sleep(1);
    $this->anotherFunction($int - 1);
  }

}
