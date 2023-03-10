<?php

namespace Drupal\my_custom_module\traits;

/**
 * Implements the Singleton design pattern.
 *
 * Use "use Singleton" in any class which you want to make into a singleton,
 * see for example
 * ./drupal/custom-modules/my_custom_module/src/App.php.
 */
trait Singleton {

  /**
   * Interal instance variable used with the instance() method.
   *
   * @var object|null
   */
  static private $instance;

  /**
   * Implements the Singleton design pattern.
   *
   * Only one instance of the class should exist per execution.
   *
   * @return mixed
   *   The single instance of the class.
   */
  public static function instance() {
    // See http://stackoverflow.com/questions/15443458
    $class = get_called_class();

    // Not sure why the linter tells me $instance is not used.
    // @codingStandardsIgnoreStart
    if (!$class::$instance) {
    // @codingStandardsIgnoreEnd
      $class::$instance = new $class();
    }
    return $class::$instance;
  }

}
