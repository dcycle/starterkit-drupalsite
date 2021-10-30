<?php

namespace Drupal\my_custom_module\traits;

use Drupal\Core\Form\FormStateInterface;

/**
 * General utilities trait.
 *
 * If your class needs to use any of these, add "use Environment" your class
 * and these methods will be available and mockable in tests.
 */
trait Environment {

  /**
   * Mockable wrapper around drupal_set_message().
   */
  protected function drupalSetMessage($message = NULL, $type = 'status', $repeat = FALSE) {
    $messenger = \Drupal::messenger();

    switch ($type) {
      case 'warning':
        $messenger->addWarning($message);
        break;

      case 'status':
        $messenger->addStatus($message);
        break;

      case 'error':
        $messenger->addError($message);
        break;

      default:
        $messenger->addMessage($message);
        break;
    }
  }

  /**
   * Mockable wrapper around $form_state->getUserInput()().
   */
  protected function formStateGetUserInput(FormStateInterface $form_state) : array {
    return $form_state->getUserInput();
  }

  /**
   * Mockable wrapper around \Drupal::state()->get().
   */
  public function stateGet($variable, $default = NULL) {
    return \Drupal::state()->get($variable, $default);
  }

  /**
   * Mockable wrapper around \Drupal::state()->set().
   */
  public function stateSet($variable, $value) {
    \Drupal::state()->set($variable, $value);
  }

  /**
   * Mockable wrapper around t().
   */
  public function t($string, array $args = [], array $options = []) {
    // @codingStandardsIgnoreStart
    return t($string, $args, $options);
    // @codingStandardsIgnoreEnd
  }

}
