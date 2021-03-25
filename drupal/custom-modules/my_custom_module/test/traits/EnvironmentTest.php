<?php

namespace Drupal\my_custom_module\Tests\traits;

use Drupal\my_custom_module\traits\Environment;
use PHPUnit\Framework\TestCase;

/**
 * Dummy object using Utilities for testing.
 */
// @codingStandardsIgnoreStart
class DummyObject {
// @codingStandardsIgnoreEnd
  use Environment;

}

/**
 * Test Utilities.
 *
 * @group myproject
 */
class EnvironmentTest extends TestCase {

  /**
   * Smoke test.
   */
  public function testSmoke() {
    $object = new DummyObject();

    $this->assertTrue(is_object($object), 'It is possible for an object to use the Environment trait.');
  }

}
