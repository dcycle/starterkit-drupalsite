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
   * Log a \Throwable to the watchdog.
   *
   * Modeled after Core's watchdog_exception().
   *
   * @param \Throwable $t
   *   A \throwable.
   * @param mixed $message
   *   The message to store in the log. If empty, a text that contains all
   *   useful information about the passed-in exception is used.
   * @param mixed $variables
   *   Array of variables to replace in the message on display or NULL if
   *   message is already translated or not possible to translate.
   * @param mixed $severity
   *   The severity of the message, as per RFC 3164.
   * @param mixed $link
   *   A link to associate with the message.
   */
  public function watchdogThrowable(\Throwable $t, $message = NULL, $variables = [], $severity = RfcLogLevel::ERROR, $link = NULL) {

    // Use a default value if $message is not set.
    if (empty($message)) {
      $message = '%type: @message in %function (line %line of %file).';
    }

    if ($link) {
      $variables['link'] = $link;
    }

    $variables += Error::decodeException($t);

    \Drupal::logger('steward_common')->log($severity, $message, $variables);
  }

}
