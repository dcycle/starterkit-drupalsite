<?php

namespace Drupal\my_custom_module\Tests\Form;

use Drupal\my_custom_module\Form\AdminSettingsForm;
use PHPUnit\Framework\TestCase;
// Note that we are not actually using Drupal here, but rather our mock
// simplified version of Drupal at ./phpunit-bootstrap.php.
use Drupal\Core\Form\FormStateInterface;

/**
 * Test AdminSettingsForm.
 *
 * @group myproject
 */
class AdminSettingsFormTest extends TestCase {

  /**
   * Test for getFormId().
   *
   * @cover ::getFormId
   */
  public function testGetFormId() {
    $object = new AdminSettingsForm();

    $output = $object->getFormId();

    $this->assertTrue(!empty($output), 'Form id exists and is not empty');
    $this->assertTrue(is_string($output), 'Form id is a string');
  }

  /**
   * Test for buildForm().
   *
   * @param string $state_value
   *   The mocked return of state_get().
   *
   * @cover ::buildForm
   * @dataProvider providerBuildForm
   */
  public function testBuildForm(string $state_value) {
    $object = $this->getMockBuilder(AdminSettingsForm::class)
      // NULL = no methods are mocked; otherwise list the methods here.
      ->setMethods([
        't',
        'stateGet',
      ])
      ->disableOriginalConstructor()
      ->getMock();

    $object->method('t')
      ->willReturn('some translated string');
    $object->method('stateGet')
      ->willReturn($state_value);

    $form = ['whatever'];
    $form_state = new FormStateInterface();

    $output = $object->buildForm($form, $form_state);

    $this->assertTrue($output['basic']['my-information']['#default_value'] == $state_value, 'Form gets its default value from a state variable.');
  }

  /**
   * Provider for testBuildForm().
   */
  public function providerBuildForm() {
    return [
      [
        'state_value' => 'Hello',
      ],
      [
        'state_value' => 'World',
      ],
    ];
  }

  /**
   * Test for submitForm().
   *
   * @param string $submitted_value
   *   The simulated submitted value in the form.
   *
   * @cover ::submitForm
   * @dataProvider providerSubmitForm
   */
  public function testSubmitForm(string $submitted_value) {
    $object = $this->getMockBuilder(AdminSettingsForm::class)
      // NULL = no methods are mocked; otherwise list the methods here.
      ->setMethods([
        'formStateGetUserInput',
        'stateSet',
        't',
        'drupalSetMessage',
      ])
      ->disableOriginalConstructor()
      ->getMock();

    $object->method('formStateGetUserInput')
      ->willReturn([
        'my-information' => $submitted_value,
      ]);
    $object->method('t')
      ->willReturn('some translated string');

    $form = ['whatever'];
    $form_state = new FormStateInterface();

    $object->expects($this->once())
      ->method('stateSet')
      ->with('my-information', $submitted_value);

    $object->submitForm($form, $form_state);
  }

  /**
   * Provider for testSubmitForm().
   */
  public function providerSubmitForm() {
    return [
      [
        'submitted_value' => 'Hello',
      ],
      [
        'submitted_value' => 'World',
      ],
    ];
  }

}
