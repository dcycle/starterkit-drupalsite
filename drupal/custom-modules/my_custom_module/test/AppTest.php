<?php

namespace Drupal\my_custom_module\Tests;

use Drupal\my_custom_module\App;
use PHPUnit\Framework\TestCase;

/**
 * Test App.
 *
 * @group myproject
 */
class AppTest extends TestCase {

  /**
   * Test for hookCron().
   *
   * @cover ::hookCron
   */
  public function testHookCron() {
    $object = $this->getMockBuilder(App::class)
      // NULL = no methods are mocked; otherwise list the methods here.
      ->setMethods(NULL)
      ->disableOriginalConstructor()
      ->getMock();

    $output = $object->hookCron();
    $this->assertTrue($output === NULL, 'Cron function exists and does not return anything.');
  }

}
